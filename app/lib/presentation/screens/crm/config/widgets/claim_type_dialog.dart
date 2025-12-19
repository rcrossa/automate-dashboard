import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/tipo_reclamo.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/utils/error_message.dart';

class ClaimTypeDialog extends ConsumerStatefulWidget {
  final TipoReclamo? tipo;

  const ClaimTypeDialog({super.key, this.tipo});

  @override
  ConsumerState<ClaimTypeDialog> createState() => _ClaimTypeDialogState();
}

class _ClaimTypeDialogState extends ConsumerState<ClaimTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombreCtrl;
  late TextEditingController _descCtrl;
  String _prioridad = 'media';
  
  // Dynamic Fields State
  // List of Maps: { 'key': 'sku', 'label': 'Código SKU', 'type': 'text', 'required': true }
  List<Map<String, dynamic>> _campos = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.tipo?.nombre ?? '');
    _descCtrl = TextEditingController(text: widget.tipo?.descripcion ?? '');
    _prioridad = widget.tipo?.prioridadDefault ?? 'media';
    
    if (widget.tipo?.camposRequeridos != null) {
      _campos = List<Map<String, dynamic>>.from(
        widget.tipo!.camposRequeridos.map((e) => Map<String, dynamic>.from(e))
      );
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _addcampo() {
    setState(() {
      _campos.add({
        'key': '',
        'label': '',
        'type': 'text', // text, number, date, boolean
        'required': false,
      });
    });
  }

  void _removeCampo(int index) {
    setState(() {
      _campos.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate fields
    for (var campo in _campos) {
      if (campo['key'].toString().isEmpty || campo['label'].toString().isEmpty) {
        ErrorMessage.show(context, 'Todos los campos dinámicos deben tener Clave y Etiqueta', isError: true);
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(crmConfigRepositoryProvider);
      final session = ref.read(userStateProvider).asData?.value;
      
      if (session?.empresa?.id == null) throw Exception('No hay empresa en sesión');

      final newTipo = TipoReclamo(
        id: widget.tipo?.id ?? 0, // 0 for create
        empresaId: session!.empresa!.id,
        nombre: _nombreCtrl.text.trim(),
        descripcion: _descCtrl.text.trim(),
        prioridadDefault: _prioridad,
        camposRequeridos: _campos,
        activo: true,
      );

      if (widget.tipo == null) {
        await repository.createTipoReclamo(newTipo);
      } else {
        await repository.updateTipoReclamo(newTipo);
      }

      if (mounted) {
        ErrorMessage.show(context, 'Tipo de Reclamo guardado');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 700,
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.tipo == null ? 'Nuevo Tipo de Reclamo' : 'Editar Tipo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                ],
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info
                      Text('Información General', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: InputDecoration(labelText: 'Nombre (ej: "Producto Defectuoso")', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                        maxLines: 2,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _prioridad,
                        items: ['baja', 'media', 'alta', 'urgente'].map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase()))).toList(),
                        onChanged: (val) => setState(() => _prioridad = val!),
                        decoration: InputDecoration(labelText: 'Prioridad por Defecto', border: OutlineInputBorder()),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Dynamic Fields Builder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Campos del Formulario', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          TextButton.icon(onPressed: _addcampo, icon: Icon(Icons.add), label: Text('Agregar Campo')),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (_campos.isEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.grey[100],
                          child: Center(child: Text('Sin campos extra. Solo se pedirá Título y Descripción.')),
                        ),
                      
                      ..._campos.asMap().entries.map((entry) {
                        final index = entry.key;
                        final campo = entry.value;
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: campo['label'],
                                        decoration: const InputDecoration(
                                          labelText: 'Nombre del Campo (Visible)',
                                          hintText: 'Ej: Color del Producto',
                                          prefixIcon: Icon(Icons.label),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (val) {
                                          campo['label'] = val;
                                          // Auto-generate key mostly if it was empty or matches old pattern
                                          // Keeping it simple: only if key is empty/basic, update it?
                                          // Or let user override.
                                          if (campo['key'].isEmpty) {
                                              campo['key'] = val.toLowerCase().trim().replaceAll(' ', '_');
                                              // Force rebuild to show new key? No, TextFormField initialValue doesn't update unless key changes.
                                              // We'll leave it simple for now, user can edit ID separately.
                                              setState(() {});
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeCampo(index),
                                      tooltip: 'Eliminar Campo',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        key: ValueKey('key_${index}_${campo['key']}'), // Logic to force update if key changed externally
                                        initialValue: campo['key'],
                                        decoration: const InputDecoration(
                                          labelText: 'ID Interno (Automático)',
                                          helperText: 'Identificador único en base de datos',
                                          prefixIcon: Icon(Icons.code),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Color(0xFFF9F9F9),
                                        ),
                                        style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
                                        onChanged: (val) => campo['key'] = val,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: DropdownButtonFormField<String>(
                                        value: campo['type'],
                                        decoration: const InputDecoration(
                                          labelText: 'Tipo de Dato',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        items: const [
                                          DropdownMenuItem(value: 'text', child: Row(children: [Icon(Icons.text_fields, size: 16), SizedBox(width: 8), Text('Texto')])),
                                          DropdownMenuItem(value: 'number', child: Row(children: [Icon(Icons.numbers, size: 16), SizedBox(width: 8), Text('Número')])),
                                          DropdownMenuItem(value: 'date', child: Row(children: [Icon(Icons.calendar_today, size: 16), SizedBox(width: 8), Text('Fecha')])),
                                          DropdownMenuItem(value: 'boolean', child: Row(children: [Icon(Icons.check_box, size: 16), SizedBox(width: 8), Text('Si/No')])),
                                        ],
                                        onChanged: (val) => setState(() => campo['type'] = val),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    FilterChip(
                                      label: const Text('Obligatorio'),
                                      selected: campo['required'] == true,
                                      onSelected: (val) => setState(() => campo['required'] = val),
                                      checkmarkColor: Colors.white,
                                      selectedColor: Theme.of(context).primaryColor,
                                      labelStyle: TextStyle(color: campo['required'] == true ? Colors.white : Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).map((e) => e),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Guardar Configuración'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
