import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_message.dart';

class EmployeeDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? empleado;
  final int empresaId;
  final List<Map<String, dynamic>> sucursales;
  final VoidCallback onSuccess;

  const EmployeeDialog({
    super.key,
    this.empleado,
    required this.empresaId,
    required this.sucursales,
    required this.onSuccess,
  });

  @override
  ConsumerState<EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends ConsumerState<EmployeeDialog> {
  late TextEditingController emailCtrl;
  late TextEditingController nombreCtrl;
  late TextEditingController apellidoCtrl;
  late TextEditingController usernameCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController direccionCtrl;
  late TextEditingController docIdCtrl;
  
  int? selectedSucursalId;
  String selectedRol = 'usuario';
  bool esEdicion = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    esEdicion = widget.empleado != null;
    emailCtrl = TextEditingController(text: widget.empleado?['email']);
    nombreCtrl = TextEditingController(text: widget.empleado?['nombre']);
    apellidoCtrl = TextEditingController(text: widget.empleado?['apellido']);
    usernameCtrl = TextEditingController(text: widget.empleado?['username']);
    telefonoCtrl = TextEditingController(text: widget.empleado?['telefono']);
    direccionCtrl = TextEditingController(text: widget.empleado?['direccion']);
    docIdCtrl = TextEditingController(text: widget.empleado?['documento_identidad']);
    
    selectedSucursalId = widget.empleado?['sucursal_id'];
    selectedRol = widget.empleado?['roles']['nombre'] ?? 'usuario';
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    usernameCtrl.dispose();
    telefonoCtrl.dispose();
    direccionCtrl.dispose();
    docIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _cargando = true);
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(companyRepositoryProvider);

    try {
      if (esEdicion) {
        await repo.updateEmployee(
          userId: widget.empleado!['id'],
          branchId: selectedSucursalId,
          roleName: selectedRol,
          name: nombreCtrl.text,
          lastName: apellidoCtrl.text,
          username: usernameCtrl.text,
          phone: telefonoCtrl.text,
          address: direccionCtrl.text,
          documentId: docIdCtrl.text,
          companyId: widget.empresaId,
        );
      } else {
        await repo.inviteEmployee(
          email: emailCtrl.text,
          branchId: selectedSucursalId,
          roleName: selectedRol,
          companyId: widget.empresaId,
        );
      }

      if (mounted) {
        widget.onSuccess();
        navigator.pop();
        ErrorMessage.showSuccess(context, esEdicion ? l10n.userUpdated : l10n.invitationSent);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ErrorMessage.show(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(esEdicion ? l10n.editPersonnel : l10n.invitePersonnel),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl, 
              decoration: InputDecoration(labelText: l10n.emailLabel), 
              enabled: !esEdicion,
            ),
            if (esEdicion) ...[
              const SizedBox(height: 8),
              TextField(controller: nombreCtrl, decoration: InputDecoration(labelText: l10n.nameLabel)),
              const SizedBox(height: 8),
              TextField(controller: apellidoCtrl, decoration: InputDecoration(labelText: l10n.lastNameLabel)),
              const SizedBox(height: 8),
              TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: l10n.usernameFieldLabel)),
              const SizedBox(height: 8),
              TextField(controller: docIdCtrl, decoration: InputDecoration(labelText: l10n.docIdLabel)),
              const SizedBox(height: 8),
              TextField(controller: telefonoCtrl, decoration: InputDecoration(labelText: l10n.phoneLabel)),
              const SizedBox(height: 8),
              TextField(controller: direccionCtrl, decoration: InputDecoration(labelText: l10n.addressLabel)),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRol,
              decoration: InputDecoration(labelText: l10n.roleLabel),
              items: [
                DropdownMenuItem(value: 'admin', child: Text(l10n.adminRole)),
                DropdownMenuItem(value: 'gerente', child: Text(l10n.managerRole)),
                DropdownMenuItem(value: 'usuario', child: Text(l10n.userRole)),
              ],
              onChanged: (val) => setState(() => selectedRol = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedSucursalId,
              decoration: InputDecoration(labelText: l10n.branchOptionalLabel),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.noBranchMatrixLabel)),
                ...widget.sucursales.map((s) => DropdownMenuItem<int>(
                      value: s['id'],
                      child: Text(s['nombre']),
                    )),
              ],
              onChanged: (val) => setState(() => selectedSucursalId = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        ElevatedButton(
          onPressed: _cargando ? null : _guardar,
          child: _cargando 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(esEdicion ? l10n.save : l10n.invite),
        ),
      ],
    );
  }
}
