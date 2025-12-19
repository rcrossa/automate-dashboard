import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import 'package:msasb_app/presentation/providers/admin_repository_provider.dart';
import 'widgets/create_company_dialog.dart';
import 'widgets/empresa_card.dart';
import 'widgets/invitacion_card.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

class SuperAdminDashboardScreen extends ConsumerStatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  ConsumerState<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends ConsumerState<SuperAdminDashboardScreen> {
  List<Map<String, dynamic>> _empresas = [];
  List<Map<String, dynamic>> _invitaciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
    setState(() => _cargando = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final datos = await repo.getCompanies();
      final invs = await repo.getPendingInvitations();
      if (mounted) {
        setState(() {
          _empresas = datos;
          _invitaciones = invs;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _mostrarDialogoCrearEmpresa() {
    showDialog(
      context: context,
      builder: (context) => CreateCompanyDialog(
        onSuccess: () {
          _cargarEmpresas();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.superAdminDashboardTitle),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(usuario: ref.watch(userStateProvider).asData?.value.usuario),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_create_company',
        onPressed: _mostrarDialogoCrearEmpresa,
        child: const Icon(Icons.add_business),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 1100;
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Panel Izquierdo: Empresas
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(l10n.companiesSection, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.3, // Adjusted to prevent overflow
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: _empresas.length,
                                itemBuilder: (context, index) => EmpresaCard(empresaData: _empresas[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // Panel Derecho: Invitaciones
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(l10n.pendingInvitationsSection, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _invitaciones.length,
                                itemBuilder: (context, index) => InvitacionCard(
                                  invitacionData: _invitaciones[index],
                                  onDeleted: _cargarEmpresas,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile Layout
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(l10n.companiesSection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _empresas.length,
                          itemBuilder: (context, index) => EmpresaCard(empresaData: _empresas[index]),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(l10n.pendingInvitationsSection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: _invitaciones.isEmpty
                            ? Center(child: Text(l10n.noPendingInvitations))
                            : ListView.builder(
                                itemCount: _invitaciones.length,
                                itemBuilder: (context, index) => InvitacionCard(
                                  invitacionData: _invitaciones[index],
                                  onDeleted: _cargarEmpresas,
                                ),
                              ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }



}
