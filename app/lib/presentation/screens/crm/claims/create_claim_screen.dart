import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/tipo_reclamo.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/widgets/client_selector.dart';

class CreateClaimScreen extends ConsumerStatefulWidget {
  const CreateClaimScreen({super.key});

  @override
  ConsumerState<CreateClaimScreen> createState() => _CreateClaimScreenState();
}

class _CreateClaimScreenState extends ConsumerState<CreateClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Data
  List<TipoReclamo> _tipos = [];
  TipoReclamo? _selectedTipo;
  Cliente? _selectedClient;
  
  // Branch Selection
  List<Map<String, dynamic>> _sucursales = [];
  int? _selectedSucursalId;
  
  // Controllers
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _priority = 'media';
  String _urgencia = 'media';
  
  // Dynamic Values
  final Map<String, dynamic> _dynamicValues = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final session = ref.read(userStateProvider).asData?.value;
      if (session?.usuario == null) return;
      
      final crmRepo = ref.read(crmConfigRepositoryProvider);
      final companyRepo = ref.read(companyRepositoryProvider);
      
      // Load Types and Branches in parallel
      final results = await Future.wait([
        crmRepo.getTiposReclamo(empresaId: session!.empresa!.id),
        companyRepo.getBranches(companyId: session.empresa!.id),
      ]);
      
      final tipos = results[0] as List<TipoReclamo>;
      final sucursales = results[1] as List<Map<String, dynamic>>;
      
      if (mounted) {
        setState(() {
          _tipos = tipos.where((t) => t.activo).toList();
          _sucursales = sucursales;
          // Pre-select user's branch if valid
          _selectedSucursalId ??= session.usuario!.sucursalId;
          // Verify if user's branch exists in fetched list (it should)
        });
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error cargando datos: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate dynamic required fields
    if (_selectedTipo != null) {
      for (var campo in _selectedTipo!.camposRequeridos) {
        if (campo['required'] == true) {
          final key = campo['key'];
          if (_dynamicValues[key] == null || _dynamicValues[key].toString().isEmpty) {
            ErrorMessage.show(context, 'El campo "${campo['label']}" es obligatorio', isError: true);
            return;
          }
        }
      }
    }

    setState(() => _isLoading = true);
    
    try {
      final userState = ref.read(userStateProvider);
      final session = userState.asData?.value;
      if (session?.usuario?.id == null) throw Exception('No session');

      final repo = ref.read(reclamoRepositoryProvider);
      
      await repo.createClaim(
        userId: session!.usuario!.id,
        empresaId: session.empresa!.id,
        // Use selected branch OR fallback to user's branch (though selection is preferred)
        sucursalId: _selectedSucursalId ?? session.usuario!.sucursalId,
        clientId: _selectedClient?.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        priority: _priority,
        tipoReclamoId: _selectedTipo?.id,
        datosExtra: _dynamicValues,
        urgencia: _urgencia,
      );

      if (mounted) {
        ErrorMessage.show(context, 'Reclamo creado exitosamente');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ErrorMessage.show(context, 'Error creando reclamo: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Reclamo')),
      body: _isLoading && _tipos.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // 0. Client Selection
                   ClientSelector(
                     onSelected: (c) => setState(() => _selectedClient = c),
                   ),
                   const SizedBox(height: 16),
                   
                   // Branch Selection (if available)
                   if (_sucursales.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Sucursal',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.store),
                        ),
                        value: _selectedSucursalId,
                        items: _sucursales.map((s) => DropdownMenuItem<int>(
                          value: s['id'] as int,
                          child: Text(s['nombre'] ?? 'Sin Nombre'),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedSucursalId = val),
                        validator: (v) => v == null ? 'Seleccione una sucursal' : null,
                      ),
                      const SizedBox(height: 16),
                   ],

                   // 1. Tipo Selection
                   DropdownButtonFormField<TipoReclamo>(
                     decoration: const InputDecoration(
                       labelText: 'Tipo de Reclamo',
                       border: OutlineInputBorder(),
                       prefixIcon: Icon(Icons.category),
                     ),
                     value: _selectedTipo,
                     items: _tipos.map((t) => DropdownMenuItem(
                       value: t, 
                       child: Text(t.nombre),
                     )).toList(),
                     onChanged: (val) {
                       setState(() {
                         _selectedTipo = val;
                         // Initialize default priority if type changes
                         if (val?.prioridadDefault != null) {
                           _priority = val!.prioridadDefault;
                         }
                         // Reset dynamic values potentially or keep?
                         // Better reset to avoid dirty data
                         _dynamicValues.clear();
                       });
                     },
                     validator: (v) => v == null ? 'Seleccione un tipo' : null,
                   ),
                   const SizedBox(height: 16),
                   
                   // 2. Basic Info
                   TextFormField(
                     controller: _titleCtrl,
                     decoration: const InputDecoration(
                       labelText: 'Título del Reclamo',
                       border: OutlineInputBorder(),
                       prefixIcon: Icon(Icons.title),
                     ),
                     validator: (v) => v!.isEmpty ? 'Requerido' : null,
                   ),
                   const SizedBox(height: 16),
                   
                   TextFormField(
                     controller: _descCtrl,
                     decoration: const InputDecoration(
                       labelText: 'Descripción Detallada',
                       border: OutlineInputBorder(),
                       prefixIcon: Icon(Icons.description),
                       alignLabelWithHint: true,
                     ),
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
                   
                   // 3. Dynamic Fields
                   if (_selectedTipo != null && _selectedTipo!.camposRequeridos.isNotEmpty) ...[
                     const SizedBox(height: 24),
                     const Divider(),
                     const Padding(
                       padding: EdgeInsets.symmetric(vertical: 8.0),
                       child: Text('Información Adicional (Dinámica)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     ),
                     Card(
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           children: _selectedTipo!.camposRequeridos.map((campo) {
                             return Padding(
                               padding: const EdgeInsets.only(bottom: 16.0),
                               child: _buildDynamicField(campo),
                             );
                           }).toList(),
                         ),
                       ),
                     ),
                   ],
                   
                   const SizedBox(height: 32),
                   SizedBox(
                     height: 50,
                     child: ElevatedButton.icon(
                       onPressed: _isLoading ? null : _save,
                       icon: const Icon(Icons.save),
                       label: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Crear Reclamo'),
                     ),
                   ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDynamicField(Map<String, dynamic> campo) {
      final key = campo['key'];
      final label = campo['label'];
      final type = campo['type'];
      final required = campo['required'] == true;
      
      switch (type) {
        case 'boolean':
          return SwitchListTile(
            title: Text(label),
            value: _dynamicValues[key] == true,
            onChanged: (val) => setState(() => _dynamicValues[key] = val),
            contentPadding: EdgeInsets.zero,
          );
        case 'date':
           // Simplificado: Text input que parsea fecha o usar date picker
           // Por rapidez usaré DatePicker
           return InkWell(
             onTap: () async {
               final date = await showDatePicker(
                 context: context, 
                 initialDate: DateTime.now(), 
                 firstDate: DateTime(2000), 
                 lastDate: DateTime(2100)
               );
               if (date != null) {
                 setState(() => _dynamicValues[key] = date.toIso8601String().split('T')[0]);
               }
             },
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label + (required ? ' *' : ''),
                 border: const OutlineInputBorder(),
                 suffixIcon: const Icon(Icons.calendar_today),
               ),
               child: Text(_dynamicValues[key]?.toString() ?? 'Seleccionar fecha'),
             ),
           );
        case 'number':
           return TextFormField(
             keyboardType: TextInputType.number,
             decoration: InputDecoration(
               labelText: label + (required ? ' *' : ''),
               border: const OutlineInputBorder(),
             ),
             onChanged: (val) => _dynamicValues[key] = num.tryParse(val),
             validator: (val) {
               if (required && (val == null || val.isEmpty)) return 'Requerido';
               return null;
             },
           );
        case 'text':
        default:
           return TextFormField(
             decoration: InputDecoration(
               labelText: label + (required ? ' *' : ''),
               border: const OutlineInputBorder(),
             ),
             onChanged: (val) => _dynamicValues[key] = val,
             validator: (val) {
               if (required && (val == null || val.isEmpty)) return 'Requerido';
               return null;
             },
           );
      }
  }
}
