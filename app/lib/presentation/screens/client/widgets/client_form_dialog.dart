import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/providers/client_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
class ClientFormDialog extends ConsumerStatefulWidget {
  final Cliente? cliente; // Si es null, es creación. Si no, edición.
  final int? empresaId; // Requerido si es creación
  final int? sucursalId; // Requerido si es creación

  const ClientFormDialog({
    super.key,
    this.cliente,
    this.empresaId,
    this.sucursalId,
  });

  @override
  ConsumerState<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends ConsumerState<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _dniCtrl;
  late TextEditingController _razonSocialCtrl;
  late TextEditingController _cuitCtrl;
  late TextEditingController _notasCtrl;
  String _tipoCliente = 'persona';
  bool _isLoading = false;
  int? _selectedBranchId;
  List<Map<String, dynamic>> _branches = [];
  bool _isLoadingBranches = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.cliente?.nombre ?? '');
    _apellidoCtrl = TextEditingController(text: widget.cliente?.apellido ?? '');
    _emailCtrl = TextEditingController(text: widget.cliente?.email ?? '');
    _telefonoCtrl = TextEditingController(text: widget.cliente?.telefono ?? '');
    _direccionCtrl = TextEditingController(text: widget.cliente?.direccion ?? '');
    _dniCtrl = TextEditingController(text: widget.cliente?.documentoIdentidad ?? '');
    _razonSocialCtrl = TextEditingController(text: widget.cliente?.razonSocial ?? '');
    _cuitCtrl = TextEditingController(text: widget.cliente?.cuit ?? '');
    _notasCtrl = TextEditingController(text: widget.cliente?.notas ?? '');
    _tipoCliente = widget.cliente?.tipoCliente ?? 'persona';
    
    // Si editamos, usamos sucursal del cliente. Si creamos, la que venga por props o null.
    // Nota: Si el usuario es 'usuario', esto ya viene fijo (widget.sucursalId).
    _selectedBranchId = widget.cliente?.sucursalId ?? widget.sucursalId;

    _loadBranches();
  }

  Future<void> _loadBranches() async {
    // Solo cargar sucursales si el usuario es Admin/SuperAdmin y puede elegir.
    // Si viene un sucursalId fijo (Usuario normal), no hace falta cargar lista para elegir.
    
    // Sin embargo, para simplificar vamos a intentar cargar si tenemos empresaId
    final session = ref.read(userStateProvider).asData?.value;
    final empId = widget.empresaId ?? session?.empresa?.id ?? session?.usuario?.empresaId;
    
    if (empId == null) return; // No podemos cargar ramas sin empresa

    // Verificar si el usuario puede gestionar sucursales (es Admin)
    final isAdmin = session?.usuario?.rol == 'admin' || session?.usuario?.rol == 'super_admin';
    if (!isAdmin) return; // Usuarios normales no eligen

    setState(() => _isLoadingBranches = true);
    try {
      final repo = ref.read(companyRepositoryProvider);
      final list = await repo.getBranches(companyId: empId);
      if (mounted) {
        setState(() {
          _branches = list;
        });
      }
    } catch (e) {
      debugPrint('Error loading branches: $e');
    } finally {
      if (mounted) setState(() => _isLoadingBranches = false);
    }
  }

  // ... dispose ...
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _dniCtrl.dispose();
    _razonSocialCtrl.dispose();
    _cuitCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(clientRepositoryProvider);
      
      final session = ref.read(userStateProvider).asData?.value;
      final empId = widget.empresaId ?? session?.empresa?.id ?? session?.usuario?.empresaId;
      
      // La sucursal es: la elegida en el combo (si hay), o la fija del widget/sesion.
      // Si el combo está activo (usuario admin), _selectedBranchId tiene lo que eligió (o null para global).
      final sucId = _branches.isNotEmpty ? _selectedBranchId : (widget.sucursalId ?? session?.sucursal?.id ?? session?.usuario?.sucursalId);

      if (empId == null) {
        throw Exception(AppLocalizations.of(context)!.errorNoCompanyContext);
      }

      if (widget.cliente == null) {
        // CREAR
        final nuevo = Cliente(
          id: 0,
          empresaId: empId,
          sucursalId: sucId,
          nombre: _nombreCtrl.text.trim(),
          apellido: _apellidoCtrl.text.trim().isEmpty ? null : _apellidoCtrl.text.trim(),
          razonSocial: _razonSocialCtrl.text.trim().isEmpty ? null : _razonSocialCtrl.text.trim(),
          cuit: _cuitCtrl.text.trim().isEmpty ? null : _cuitCtrl.text.trim(),
          tipoCliente: _tipoCliente,
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
          direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
          documentoIdentidad: _dniCtrl.text.trim().isEmpty ? null : _dniCtrl.text.trim(),
          notas: _notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim(),
          estado: 'activo',
          fechaCreacion: DateTime.now(),
          actualizadoEn: DateTime.now(),
        );
        await repo.createClient(nuevo);
      } else {
        // EDITAR
        final editado = Cliente(
          id: widget.cliente!.id,
          empresaId: widget.cliente!.empresaId,
          sucursalId: sucId,
          nombre: _nombreCtrl.text.trim(),
          apellido: _apellidoCtrl.text.trim().isEmpty ? null : _apellidoCtrl.text.trim(),
          razonSocial: _razonSocialCtrl.text.trim().isEmpty ? null : _razonSocialCtrl.text.trim(),
          cuit: _cuitCtrl.text.trim().isEmpty ? null : _cuitCtrl.text.trim(),
          tipoCliente: _tipoCliente,
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
          direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
          documentoIdentidad: _dniCtrl.text.trim().isEmpty ? null : _dniCtrl.text.trim(),
          notas: _notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim(),
          estado: widget.cliente!.estado,
          fechaCreacion: widget.cliente!.fechaCreacion,
          actualizadoEn: DateTime.now(),
        );
        await repo.updateClient(editado);
      }

      if (mounted) {
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        ErrorMessage.show(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.cliente == null ? l10n.clientFormTitleNew : l10n.clientFormTitleEdit;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoadingBranches)
                const LinearProgressIndicator()
              else if (_branches.isNotEmpty)
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: l10n.labelBranch),
                  value: _selectedBranchId,
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text(l10n.labelHeadquarters),
                    ),
                    ..._branches.map((b) => DropdownMenuItem<int>(
                          value: b['id'] as int,
                          child: Text(b['nombre'] as String),
                        ))
                  ],
                  onChanged: (val) => setState(() => _selectedBranchId = val),
                ),
              if (_branches.isNotEmpty) const SizedBox(height: 10),

              Row(
                children: [
                   Expanded(
                     child: RadioListTile<String>(
                       title: Text(l10n.typePerson),
                       value: 'persona',
                       groupValue: _tipoCliente,
                       onChanged: (v) => setState(() => _tipoCliente = v!),
                       contentPadding: EdgeInsets.zero,
                     ),
                   ),
                   Expanded(
                     child: RadioListTile<String>(
                       title: Text(l10n.typeCompany),
                       value: 'empresa',
                       groupValue: _tipoCliente,
                       onChanged: (v) => setState(() => _tipoCliente = v!),
                       contentPadding: EdgeInsets.zero,
                     ),
                   ),
                ],
              ),
              const Divider(),

              if (_tipoCliente == 'empresa') ...[
                TextFormField(
                  controller: _razonSocialCtrl,
                  decoration: InputDecoration(labelText: l10n.labelBusinessName),
                  validator: (v) => _tipoCliente == 'empresa' && (v == null || v.isEmpty) ? l10n.validationRequired : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cuitCtrl,
                  decoration: InputDecoration(labelText: l10n.labelTaxId),
                  validator: (v) => _tipoCliente == 'empresa' && (v == null || v.isEmpty) ? l10n.validationRequired : null,
                ),
                const SizedBox(height: 10),
              ],

              TextFormField(
                controller: _nombreCtrl,
                decoration: InputDecoration(labelText: _tipoCliente == 'empresa' ? l10n.labelContactName : l10n.labelName),
                validator: (v) => v == null || v.isEmpty ? l10n.validationRequired : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: InputDecoration(labelText: _tipoCliente == 'empresa' ? l10n.labelContactLastName : l10n.labelLastName),
              ),
              const SizedBox(height: 10),
              
              if (_tipoCliente == 'persona') ...[
                TextFormField(
                  controller: _dniCtrl,
                  decoration: InputDecoration(labelText: l10n.labelIdDocument),
                ),
                const SizedBox(height: 10),
              ],
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: l10n.labelEmail),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefonoCtrl,
                decoration: InputDecoration(labelText: l10n.labelPhone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _direccionCtrl,
                decoration: InputDecoration(labelText: l10n.labelAddress),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notasCtrl,
                decoration: InputDecoration(labelText: l10n.labelNotes),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.btnCancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.btnSave),
        ),
      ],
    );
  }
}
