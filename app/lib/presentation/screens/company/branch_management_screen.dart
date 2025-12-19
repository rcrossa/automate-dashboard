import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'widgets/branch_card.dart';
import 'widgets/branch_dialog.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/error_handler.dart';

class BranchManagementScreen extends ConsumerStatefulWidget {
  const BranchManagementScreen({super.key});

  @override
  ConsumerState<BranchManagementScreen> createState() => _BranchManagementScreenState();
}

class _BranchManagementScreenState extends ConsumerState<BranchManagementScreen> {
  List<Map<String, dynamic>> _sucursales = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarSucursales();
    });
  }

  Future<void> _cargarSucursales() async {
    if (!mounted) return;
    setState(() => _cargando = true);
    
    final session = ref.read(userStateProvider).asData?.value;
    final empresaId = session?.empresa?.id;

    if (empresaId == null) {
       if (mounted) {
        setState(() => _cargando = false);
        final l10n = AppLocalizations.of(context)!;
        ErrorHandler.showError(context, l10n.errorNoCompanyContext);
       }
       return;
    }

    try {
      final repo = ref.read(companyRepositoryProvider);
      final datos = await repo.getBranches(companyId: empresaId);
      if (mounted) setState(() => _sucursales = datos);
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _mostrarDialogoCrearEditar({Map<String, dynamic>? sucursal}) {
    final session = ref.read(userStateProvider).asData?.value;
    final empresaId = session?.empresa?.id;

    if (empresaId == null) return;

    showDialog(
      context: context,
      builder: (context) => BranchDialog(
        sucursal: sucursal,
        empresaId: empresaId,
        onSuccess: _cargarSucursales,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.branchManagementTitle),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCrearEditar(),
        child: const Icon(Icons.add),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _sucursales.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noBranchesRegistered))
              : ListView.builder(
                  itemCount: _sucursales.length,
                  itemBuilder: (context, index) {
                    final suc = _sucursales[index];
                    return BranchCard(
                      sucursal: suc,
                      onEdit: () => _mostrarDialogoCrearEditar(sucursal: suc),
                    );
                  },
                ),
    );
  }
}

