import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'tabs/company_branches_tab.dart';
import 'tabs/company_personnel_tab.dart';
import 'tabs/company_summary_tab.dart';
import 'package:msasb_app/presentation/screens/client/client_list_screen.dart';
import 'marketplace_screen.dart';
import 'widgets/company_desktop_layout.dart';
import 'widgets/company_mobile_layout.dart';
import 'package:msasb_app/presentation/screens/crm/config/crm_config_screen.dart';
import 'package:msasb_app/presentation/providers/module_provider.dart';
import 'package:msasb_app/presentation/screens/crm/claims/claims_list_screen.dart';

import 'package:msasb_app/domain/entities/empresa.dart';

class CompanyDashboardScreen extends ConsumerStatefulWidget {
  final Empresa? empresaOverride; // Para Super Admin

  const CompanyDashboardScreen({super.key, this.empresaOverride});

  @override
  ConsumerState<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}


class _CompanyDashboardScreenState extends ConsumerState<CompanyDashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Start with minimum 4 tabs, will adjust in build()
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }

  void _navigateToMarketplace(BuildContext context, int? empresaId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarketplaceScreen(empresaId: empresaId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    final session = userState.asData?.value;
    final empresa = widget.empresaOverride ?? session?.empresa;
    
    // Watch active modules and user role logic
    final activeModulesFunc = ref.watch(activeModulesProvider);
    final activeModules = activeModulesFunc.asData?.value ?? [];
    
    // Determine the actual role used (provider or session fallback)
    final userRole = session?.usuario?.rol;

    if (empresa == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabs = <Widget>[
      CompanySummaryTab(
        empresaId: empresa.id,
        onTabChange: _onTabChange,
      ),
      CompanyBranchesTab(empresaId: empresa.id),
      CompanyPersonnelTab(empresaId: empresa.id),
      ClientListScreen(empresaId: empresa.id),
    ];
    
    // Add Operational CRM tab (Claims)
    if (activeModules.contains('reclamos')) {
       tabs.add(const ClaimsListScreen());
    }
    
    // Add CRM Config tab if active and permitted
    if ((userRole == 'admin' || userRole == 'super_admin') && 
        activeModules.contains('reclamos')) {
       tabs.add(const CrmConfigScreen());
    }

    // Ensure TabController matches current tabs length (due to dynamic modules)
    if (_tabController.length != tabs.length) {
      _tabController.dispose();
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {
            _selectedIndex = _tabController.index;
          });
        }
      });
      if (_selectedIndex >= tabs.length) _selectedIndex = 0;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint custom para dashboard: 800px (más flexible que 1200px)
        final isDesktopLayout = MediaQuery.of(context).size.width >= 800;
        
        if (isDesktopLayout) {
          // DESKTOP LAYOUT (>= 800px)
          return CompanyDesktopLayout(
            empresa: empresa,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            tabs: tabs,
            onMarketplace: () => _navigateToMarketplace(context, empresa.id),
            onLogout: () async => await Supabase.instance.client.auth.signOut(),
            activeModules: activeModules,
            userRole: userRole,
            onCrmConfig: () {
               // Assuming CRM is the last tab if present
               setState(() => _selectedIndex = tabs.length - 1);
            },
          );
        } else {
          // MOBILE / TABLET LAYOUT (< 1200px)
          // TODO: Crear layout específico para tablet en futuro si es necesario
          return CompanyMobileLayout(
            empresa: empresa,
            tabController: _tabController,
            tabs: tabs,
            onMarketplace: () => _navigateToMarketplace(context, empresa.id),
            onLogout: () async => await Supabase.instance.client.auth.signOut(),
            activeModules: activeModules,
            userRole: userRole,
          );
        }
      },
    );
  }
}
