import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/domain/entities/tipo_reclamo.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';

class EditClaimScreen extends ConsumerStatefulWidget {
  final Reclamo claim;

  const EditClaimScreen({super.key, required this.claim});

  @override
  ConsumerState<EditClaimScreen> createState() => _EditClaimScreenState();
}

class _EditClaimScreenState extends ConsumerState<EditClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late String _priority;
  late String _urgencia;
  late String _estado;
  
  Map<String, dynamic> _dynamicValues = {};
  
  // To fetch label names for types if needed, but for now we just edit fields.
  // We assume the type cannot be changed easily because it implies different fields.
  // So we just load the fields for the CURRENT type.
  TipoReclamo? _currentTipo;
  
  // Branch Selection
  List<Map<String, dynamic>> _sucursales = [];
  int? _selectedSucursalId;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.claim.titulo);
    _descCtrl = TextEditingController(text: widget.claim.descripcion);
    _priority = widget.claim.prioridad;
    _urgencia = widget.claim.urgencia;
    _estado = widget.claim.estado;
    _dynamicValues = Map.from(widget.claim.datosExtra);
    
    _dynamicValues = Map.from(widget.claim.datosExtra);
    _selectedSucursalId = widget.claim.sucursalId;
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final session = ref.read(userStateProvider).asData?.value;
      if (session?.empresa == null) return;

      final crmRepo = ref.read(crmConfigRepositoryProvider);
      final companyRepo = ref.read(companyRepositoryProvider);
      
      final results = await Future.wait([
        crmRepo.getTiposReclamo(empresaId: session!.empresa!.id),
        companyRepo.getBranches(companyId: session.empresa!.id),
      ]);
      
      final tipos = results[0] as List<TipoReclamo>;
      final sucursales = results[1] as List<Map<String, dynamic>>;
      
      if (mounted) {
        setState(() {
          _sucursales = sucursales;
          _currentTipo = tipos.firstWhere((t) => t.id == widget.claim.tipoReclamoId, orElse: () => tipos.first);
        });
      }
    } catch (e) {
      debugPrint('Error parsing extra data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Ask for modification reason
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
         title: const Text('Motivo del Cambio'),
         content: TextField(
           controller: reasonCtrl,
           decoration: const InputDecoration(hintText: 'Ej: Cliente llamó para actualizar...'),
         ),
         actions: [
           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
           TextButton(
             onPressed: () => Navigator.pop(context, reasonCtrl.text),
             child: const Text('Guardar'),
           ),
         ],
      ),
    );

    if (reason == null || reason.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final userState = ref.read(userStateProvider);
      final session = userState.asData?.value;
      
      final updatedClaim = widget.claim.copyWith(
        titulo: _titleCtrl.text,
        descripcion: _descCtrl.text,
        prioridad: _priority,
        urgencia: _urgencia,
        estado: _estado,
        datosExtra: _dynamicValues,
        sucursalId: _selectedSucursalId,
      );

      final repo = ref.read(reclamoRepositoryProvider);
      await repo.updateClaim(updatedClaim, userId: session!.usuario!.id, reason: reason);

      if (mounted) {
        ErrorMessage.show(context, 'Reclamo actualizado');
        Navigator.pop(context, true); // Return true to refresh
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error actualizando: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Reclamo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               // Estado (Only reachable via Edit)
               DropdownButtonFormField<String>(
                 value: _estado,
                 decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
                 items: ['pendiente', 'en_proceso', 'resuelto', 'cerrado']
                     .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                     .toList(),
                 onChanged: (val) => setState(() => _estado = val!),
               ),
               const SizedBox(height: 16),
               
               // Branch Selector
               if (_sucursales.isNotEmpty) ...[
                  DropdownButtonFormField<int>(
                    value: _selectedSucursalId,
                    decoration: const InputDecoration(labelText: 'Sucursal', border: OutlineInputBorder()),
                    items: _sucursales.map((s) => DropdownMenuItem<int>(
                      value: s['id'] as int,
                      child: Text(s['nombre'] ?? 'Sin Nombre'),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedSucursalId = val),
                  ),
                  const SizedBox(height: 16),
               ],

               TextFormField(
                 controller: _titleCtrl,
                 decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                 validator: (v) => v!.isEmpty ? 'Requerido' : null,
               ),
               const SizedBox(height: 16),
               
               TextFormField(
                 controller: _descCtrl,
                 decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                 maxLines: 4,
                 validator: (v) => v!.isEmpty ? 'Requerido' : null,
               ),
               const SizedBox(height: 16),
               
               Row(
                 children: [
                   Expanded(
                     child: DropdownButtonFormField<String>(
                       value: _priority,
                       decoration: const InputDecoration(labelText: 'Prioridad', border: OutlineInputBorder()),
                       items: ['baja', 'media', 'alta', 'urgente'].map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase()))).toList(),
                       onChanged: (val) => setState(() => _priority = val!),
                     ),
                   ),
                   const SizedBox(width: 16),
                    Expanded(
                     child: DropdownButtonFormField<String>(
                       value: _urgencia,
                       decoration: const InputDecoration(labelText: 'Urgencia', border: OutlineInputBorder()),
                       items: ['baja', 'media', 'alta'].map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase()))).toList(),
                       onChanged: (val) => setState(() => _urgencia = val!),
                     ),
                   ),
                 ],
               ),
               
               // Dynamic Fields (If type loaded)
               if (_currentTipo != null) ...[
                 const SizedBox(height: 24),
                 const Text('Campos Dinámicos', style: TextStyle(fontWeight: FontWeight.bold)),
                 const SizedBox(height: 8),
                 ..._currentTipo!.camposRequeridos.map((campo) {
                     return Padding(
                       padding: const EdgeInsets.only(bottom: 16.0),
                       child: _buildDynamicField(campo),
                     );
                 }),
               ],

               const SizedBox(height: 32),
               ElevatedButton.icon(
                 onPressed: _isLoading ? null : _save,
                 icon: const Icon(Icons.save),
                 label: _isLoading ? const CircularProgressIndicator() : const Text('Guardar Cambios'),
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicField(Map<String, dynamic> campo) {
      final key = campo['key'];
      final label = campo['label'];
      // Assuming type matches, we reuse logic or simplify
      // Just Text input for now to cover all bases
      return TextFormField(
        initialValue: _dynamicValues[key]?.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (val) => _dynamicValues[key] = val,
      );
  }
}
