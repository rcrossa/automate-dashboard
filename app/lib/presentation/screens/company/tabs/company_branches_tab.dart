import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import '../widgets/branch_card.dart';
import '../widgets/branch_dialog.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

class CompanyBranchesTab extends ConsumerStatefulWidget {
  final int empresaId;
  const CompanyBranchesTab({super.key, required this.empresaId});

  @override
  ConsumerState<CompanyBranchesTab> createState() => _CompanyBranchesTabState();
}

class _CompanyBranchesTabState extends ConsumerState<CompanyBranchesTab> {
  List<Map<String, dynamic>> _sucursales = [];
  List<Map<String, dynamic>> _filteredSucursales = [];
  bool _cargando = true;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _searchCtrl.addListener(_filtrar);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filtrar() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredSucursales = _sucursales.where((s) {
        final nombre = s['nombre'].toString().toLowerCase();
        final direccion = s['direccion']?.toString().toLowerCase() ?? '';
        return nombre.contains(query) || direccion.contains(query);
      }).toList();
    });
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      final repo = ref.read(companyRepositoryProvider);
      final sucursales = await repo.getBranches(companyId: widget.empresaId);
      if (mounted) {
        setState(() {
          _sucursales = sucursales;
          _filteredSucursales = sucursales;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _mostrarDialogoCrearEditar({Map<String, dynamic>? sucursal}) {
    showDialog(
      context: context,
      builder: (context) => BranchDialog(
        sucursal: sucursal,
        empresaId: widget.empresaId,
        onSuccess: _cargarDatos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_branches',
        onPressed: () => _mostrarDialogoCrearEditar(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: l10n.searchBranch,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _filteredSucursales.isEmpty
                    ? Center(child: Text(l10n.noBranchesFound))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // Desktop / Tablet: Grid
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                childAspectRatio: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              padding: const EdgeInsets.all(8),
                              itemCount: _filteredSucursales.length,
                              itemBuilder: (context, index) => BranchCard(
                                sucursal: _filteredSucursales[index],
                                onEdit: () => _mostrarDialogoCrearEditar(sucursal: _filteredSucursales[index]),
                              ),
                            );
                          } else {
                            // Mobile: List
                            return ListView.builder(
                              itemCount: _filteredSucursales.length,
                              itemBuilder: (context, index) => BranchCard(
                                sucursal: _filteredSucursales[index],
                                onEdit: () => _mostrarDialogoCrearEditar(sucursal: _filteredSucursales[index]),
                              ),
                            );
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

