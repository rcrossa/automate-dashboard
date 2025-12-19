import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/empresa.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/presentation/widgets/company_logo.dart';

/// Layout para web con navegación horizontal tipo web moderna
class CompanyDesktopLayout extends StatefulWidget {
  final Empresa? empresa;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<Widget> tabs;
  final VoidCallback onMarketplace;
  final VoidCallback onLogout;
  final List<String> activeModules;
  final String? userRole;
  final VoidCallback onCrmConfig;

  const CompanyDesktopLayout({
    super.key,
    required this.empresa,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.tabs,
    required this.onMarketplace,
    required this.onLogout,
    required this.activeModules,
    required this.userRole,
    required this.onCrmConfig,
  });

  @override
  State<CompanyDesktopLayout> createState() => _CompanyDesktopLayoutState();
}

class _CompanyDesktopLayoutState extends State<CompanyDesktopLayout> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
    
    // Sincronizar cambios del tab con callback
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onDestinationSelected(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(CompanyDesktopLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Actualizar tab controller si cambia la longitud o el índice
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedIndex.clamp(0, widget.tabs.length - 1),
      );
    } else if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Construir labels de tabs
    final tabLabels = <Tab>[
      Tab(text: l10n.summary),
      Tab(text: l10n.branches),
      Tab(text: l10n.personnel),
      Tab(text: l10n.clients),
    ];
    
    if (widget.activeModules.contains('reclamos')) {
      tabLabels.add(const Tab(text: 'Reclamos'));
    }
    
    if ((widget.userRole == 'admin' || widget.userRole == 'super_admin') && 
        widget.activeModules.contains('reclamos')) {
      tabLabels.add(const Tab(text: 'CRM Config'));
    }
    
    return Scaffold(
      // AppBar con navegación horizontal (estilo web moderna)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo de empresa
            const CompanyLogo(
              height: 50,
              width: 120,
              adaptToDarkMode: true,
            ),
            const SizedBox(width: 16),
            // Nombre de empresa (flexible para no causar overflow)
            if (widget.empresa != null)
              Flexible(
                child: Text(
                  widget.empresa!.nombre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        toolbarHeight: 70,
        actions: [
          // Marketplace
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: l10n.modulesMarketplace,
            onPressed: widget.onMarketplace,
          ),
          const SizedBox(width: 8),
          // Selector de idioma
          const LanguageSelector(),
          const SizedBox(width: 8),
          // Logout
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
              onPressed: widget.onLogout,
            ),
          ),
        ],
        // TabBar horizontal debajo del header
        bottom: TabBar(
          controller: _tabController,
          isScrollable: tabLabels.length > 6, // Auto-scroll if too many tabs
          tabAlignment: tabLabels.length > 6 ? TabAlignment.start : TabAlignment.fill,
          tabs: tabLabels,
        ),
      ),
      // Contenido de los tabs
      body: TabBarView(
        controller: _tabController,
        children: widget.tabs,
      ),
    );
  }
}
