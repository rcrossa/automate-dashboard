import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/empresa.dart';
import 'package:msasb_app/widgets/app_drawer.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';

class CompanyMobileLayout extends StatelessWidget {
  final Empresa? empresa;
  final TabController tabController;
  final List<Widget> tabs;
  final VoidCallback onMarketplace;
  final VoidCallback onLogout;
  final List<String> activeModules;
  final String? userRole;

  const CompanyMobileLayout({
    super.key,
    required this.empresa,
    required this.tabController,
    required this.tabs,
    required this.onMarketplace,
    required this.onLogout,
    required this.activeModules,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Generate tab labels matching tabs list length
    final tabLabels = <Tab>[
      Tab(text: l10n.summary),
      Tab(text: l10n.branches),
      Tab(text: l10n.personnel),
      Tab(text: l10n.clients),
    ];
    
    if (activeModules.contains('reclamos')) {
      tabLabels.add(const Tab(text: 'Reclamos'));
    }
    
    if ((userRole == 'admin' || userRole == 'super_admin') && 
        activeModules.contains('reclamos')) {
      tabLabels.add(const Tab(text: 'CRM Config'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(empresa?.nombre ?? l10n.companyPanel),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: l10n.modulesMarketplace,
            onPressed: onMarketplace,
          ),
          const LanguageSelector(),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,  // Allow horizontal scrolling on mobile to prevent label compression
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          physics: const BouncingScrollPhysics(),
          tabs: tabLabels,
        ),
      ),
      drawer: AppDrawer(usuario: null),
      body: TabBarView(
        controller: tabController,
        children: tabs,
      ),
    );
  }
}
