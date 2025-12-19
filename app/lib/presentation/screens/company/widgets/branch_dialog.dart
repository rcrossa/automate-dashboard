import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

class BranchDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? sucursal;
  final int empresaId;
  final VoidCallback onSuccess;

  const BranchDialog({
    super.key,
    this.sucursal,
    required this.empresaId,
    required this.onSuccess,
  });

  @override
  ConsumerState<BranchDialog> createState() => _BranchDialogState();
}

class _BranchDialogState extends ConsumerState<BranchDialog> {
  late TextEditingController nombreCtrl;
  late TextEditingController direccionCtrl;
  bool esEdicion = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    esEdicion = widget.sucursal != null;
    nombreCtrl = TextEditingController(text: widget.sucursal?['nombre']);
    direccionCtrl = TextEditingController(text: widget.sucursal?['direccion']);
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    direccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _cargando = true);
    final navigator = Navigator.of(context);
    final repo = ref.read(companyRepositoryProvider);

    try {
      if (esEdicion) {
        await repo.updateBranch(
          id: widget.sucursal!['id'],
          name: nombreCtrl.text,
          address: direccionCtrl.text,
          companyId: widget.empresaId,
        );
      } else {
        await repo.createBranch(
          name: nombreCtrl.text,
          address: direccionCtrl.text,
          companyId: widget.empresaId,
        );
      }

      if (mounted) {
        widget.onSuccess();
        navigator.pop();
        final l10n = AppLocalizations.of(context)!;
        final message = esEdicion ? l10n.branchUpdated : l10n.branchCreated;
        ErrorHandler.showSuccess(context, message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ErrorHandler.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(esEdicion ? l10n.editBranch : l10n.newBranch),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nombreCtrl, decoration: InputDecoration(labelText: l10n.nameLabel)),
          TextField(controller: direccionCtrl, decoration: InputDecoration(labelText: l10n.addressLabel)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        ElevatedButton(
          onPressed: _cargando ? null : _guardar,
          child: _cargando 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(esEdicion ? l10n.save : l10n.create),
        ),
      ],
    );
  }
}
