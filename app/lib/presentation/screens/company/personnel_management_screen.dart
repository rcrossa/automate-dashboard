import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'widgets/employee_card.dart';
import 'widgets/employee_dialog.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/error_handler.dart';

class PersonnelManagementScreen extends ConsumerStatefulWidget {
  const PersonnelManagementScreen({super.key});

  @override
  ConsumerState<PersonnelManagementScreen> createState() => _PersonnelManagementScreenState();
}

class _PersonnelManagementScreenState extends ConsumerState<PersonnelManagementScreen> {
  List<Map<String, dynamic>> _empleados = [];
  List<Map<String, dynamic>> _sucursales = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
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
      final empleados = await repo.getEmployees(companyId: empresaId);
      final sucursales = await repo.getBranches(companyId: empresaId);
      if (mounted) {
        setState(() {
          _empleados = empleados;
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
    final session = ref.read(userStateProvider).asData?.value;
    final empresaId = session?.empresa?.id;

    if (empresaId == null) return;

    showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        empleado: empleado,
        empresaId: empresaId,
        sucursales: _sucursales,
        onSuccess: _cargarDatos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personnelManagementTitle),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoInvitarEditar(),
        child: const Icon(Icons.person_add),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _empleados.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noEmployeesRegistered))
              : ListView.builder(
                  itemCount: _empleados.length,
                  itemBuilder: (context, index) {
                    final emp = _empleados[index];
                    return EmployeeCard(
                      empleado: emp,
                      onEdit: () => _mostrarDialogoInvitarEditar(empleado: emp),
                    );
                  },
                ),
    );
  }
}

