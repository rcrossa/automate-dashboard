import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/presentation/providers/admin_repository_provider.dart';
import 'package:msasb_app/utils/responsive_helper.dart';
import 'package:msasb_app/utils/error_handler.dart';

class CreateCompanyDialog extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const CreateCompanyDialog({super.key, required this.onSuccess});

  @override
  ConsumerState<CreateCompanyDialog> createState() => _CreateCompanyDialogState();
}

class _CreateCompanyDialogState extends ConsumerState<CreateCompanyDialog> {
  final nombreCtrl = TextEditingController();
  final codigoCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final logoCtrl = TextEditingController();
  final colorCtrl = TextEditingController(text: '#2196F3'); // Default Blue
  final emailAdminCtrl = TextEditingController();
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: AlertDialog(
          title: const Text('Nueva Empresa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre Empresa')),
                TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código (ej: empresa-x)')),
                TextField(controller: direccionCtrl, decoration: const InputDecoration(labelText: 'Dirección Casa Matriz')),
                const SizedBox(height: 10),
                const Text('Branding', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(controller: logoCtrl, decoration: const InputDecoration(labelText: 'URL del Logo')),
                TextField(
                  controller: colorCtrl, 
                  decoration: const InputDecoration(
                    labelText: 'Color Tema (Hex)',
                    hintText: '#RRGGBB',
                  ),
                ),
                const Divider(),
                const Text('Invitar Admin Inicial'),
                TextField(controller: emailAdminCtrl, decoration: const InputDecoration(labelText: 'Email del Admin')),
                if (_cargando) const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
            onPressed: _cargando ? null : () => Navigator.pop(context), 
              child: const Text('Cancelar')
            ),
            ElevatedButton(
              onPressed: _cargando ? null : _crearEmpresa,
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  int? _empresaCreadaId; // Para evitar duplicados si falla la invitación y se reintenta

  Future<void> _crearEmpresa() async {
    setState(() => _cargando = true);
    final navigator = Navigator.of(context);

    try {
      final repo = ref.read(adminRepositoryProvider);
      // 1. Crear Empresa (Solo si no se ha creado ya en este intento)
      if (_empresaCreadaId == null) {
        await repo.createCompany(
          name: nombreCtrl.text,
          code: codigoCtrl.text,
          address: direccionCtrl.text,
          logoUrl: logoCtrl.text.isEmpty ? null : logoCtrl.text,
          themeColor: colorCtrl.text.isEmpty ? null : colorCtrl.text,
        );

        // Obtener el ID de la empresa recién creada
        final empresas = await repo.getCompanies();
        final nuevaEmpresa = empresas.firstWhere(
          (e) => e['codigo'] == codigoCtrl.text,
          orElse: () => throw Exception('Error al recuperar la empresa creada'),
        );
        _empresaCreadaId = nuevaEmpresa['id'];
      }

      // 2. Invitar Admin (si se puso email)
      if (emailAdminCtrl.text.trim().isNotEmpty && _empresaCreadaId != null) {
        await repo.inviteUser(
          email: emailAdminCtrl.text.trim(),
          companyId: _empresaCreadaId!,
          branchId: null,
          roleName: 'admin',
        );
      }

      if (!mounted) return;
      
      final l10n = AppLocalizations.of(context)!;
      widget.onSuccess();
      navigator.pop();
      ErrorHandler.showSuccess(context, l10n.companyCreatedSuccess);
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      
      final l10n = AppLocalizations.of(context)!;
      if (e.toString().contains('empresas_codigo_key')) {
         ErrorHandler.showError(context, l10n.companyCodeExists);
      } else {
         ErrorHandler.showError(context, e);
      }
    }
  }
}
