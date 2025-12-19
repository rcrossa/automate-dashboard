import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_dialog.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

class CompanyPersonnelTab extends ConsumerStatefulWidget {
  final int empresaId;
  const CompanyPersonnelTab({super.key, required this.empresaId});

  @override
  ConsumerState<CompanyPersonnelTab> createState() => _CompanyPersonnelTabState();
}

class _CompanyPersonnelTabState extends ConsumerState<CompanyPersonnelTab> {
  List<Map<String, dynamic>> _empleados = [];
  List<Map<String, dynamic>> _filteredEmpleados = [];
  List<Map<String, dynamic>> _sucursales = [];
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
      _filteredEmpleados = _empleados.where((e) {
        final nombre = e['nombre']?.toString().toLowerCase() ?? '';
        final email = e['email'].toString().toLowerCase();
        final rol = e['roles']['nombre'].toString().toLowerCase();
        return nombre.contains(query) || email.contains(query) || rol.contains(query);
      }).toList();
    });
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      final repo = ref.read(companyRepositoryProvider);
      final empleados = await repo.getEmployees(companyId: widget.empresaId);
      final sucursales = await repo.getBranches(companyId: widget.empresaId);
      if (mounted) {
        setState(() {
          _empleados = empleados;
          _filteredEmpleados = empleados;
          _sucursales = sucursales;
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

  void _mostrarDialogoInvitarEditar({Map<String, dynamic>? empleado}) {
    showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        empleado: empleado,
        empresaId: widget.empresaId,
        sucursales: _sucursales,
        onSuccess: _cargarDatos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_personnel',
        onPressed: () => _mostrarDialogoInvitarEditar(),
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: l10n.searchPersonnel,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _filteredEmpleados.isEmpty
                    ? Center(child: Text(l10n.noEmployeesFound))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // Desktop: Grid
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              padding: const EdgeInsets.all(8),
                              itemCount: _filteredEmpleados.length,
                              itemBuilder: (context, index) => EmployeeCard(
                                empleado: _filteredEmpleados[index],
                                onEdit: () => _mostrarDialogoInvitarEditar(empleado: _filteredEmpleados[index]),
                              ),
                            );
                          } else {
                            // Mobile: List
                            return ListView.builder(
                              itemCount: _filteredEmpleados.length,
                              itemBuilder: (context, index) => EmployeeCard(
                                empleado: _filteredEmpleados[index],
                                onEdit: () => _mostrarDialogoInvitarEditar(empleado: _filteredEmpleados[index]),
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

