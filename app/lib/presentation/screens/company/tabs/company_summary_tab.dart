import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/company_repository_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_placeholder.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/presentation/screens/admin/branding/branding_settings_screen.dart';
import 'package:msasb_app/presentation/screens/test/audio_recording_test_screen.dart'; // TEMP: Remove after testing


class CompanySummaryTab extends ConsumerStatefulWidget {
  final int empresaId;
  final Function(int)? onTabChange;
  const CompanySummaryTab({super.key, required this.empresaId, this.onTabChange});

  @override
  ConsumerState<CompanySummaryTab> createState() => _CompanySummaryTabState();
}

class _CompanySummaryTabState extends ConsumerState<CompanySummaryTab> {
  int _totalSucursales = 0;
  int _totalEmpleados = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      final repo = ref.read(companyRepositoryProvider);
      final sucursales = await repo.getBranches(companyId: widget.empresaId);
      final empleados = await repo.getEmployees(companyId: widget.empresaId);
      if (mounted) {
        setState(() {
          _totalSucursales = sucursales.length;
          _totalEmpleados = empleados.length;
        });
      }
    } catch (e) {
      // Ignorar errores en stats por ahora
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.generalSummary, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // Stats Grid
              GridView.count(
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: l10n.branches,
                    value: _totalSucursales.toString(),
                    icon: Icons.store,
                    color: Colors.blue,
                    onTap: widget.onTabChange != null ? () => widget.onTabChange!(1) : null,
                  ),
                  StatCard(
                    title: l10n.personnel,
                    value: _totalEmpleados.toString(),
                    icon: Icons.people,
                    color: Colors.green,
                    onTap: widget.onTabChange != null ? () => widget.onTabChange!(2) : null,
                  ),
                  StatCard(
                    title: l10n.incomeMonth,
                    value: '\$12.5M',
                    icon: Icons.attach_money,
                    color: Colors.orange,
                  ),
                  StatCard(
                    title: l10n.claims,
                    value: '3',
                    icon: Icons.warning_amber,
                    color: Colors.red,
                  ),
                ],
            ),
            
            const SizedBox(height: 30),
            
            // Company Configuration Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Configuración de la Empresa',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.palette, color: Colors.purple),
                      title: const Text('Personalización de Marca'),
                      subtitle: const Text('Configura colores y logos de tu empresa'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BrandingSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
              
              // Charts Section (Placeholder for now)
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ChartPlaceholder(title: l10n.incomeByBranch, bgColor: Colors.blue.shade50)),
                    const SizedBox(width: 16),
                    Expanded(child: ChartPlaceholder(title: l10n.recentActivity, bgColor: Colors.purple.shade50)),
                  ],
                )
              else
                Column(
                  children: [
                    ChartPlaceholder(title: l10n.incomeByBranch, bgColor: Colors.blue.shade50),
                    const SizedBox(height: 16),
                    ChartPlaceholder(title: l10n.recentActivity, bgColor: Colors.purple.shade50),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

