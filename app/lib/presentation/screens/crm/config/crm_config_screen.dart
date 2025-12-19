import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/claim_types_list_view.dart';
import 'widgets/interaction_types_list_view.dart';

class CrmConfigScreen extends ConsumerStatefulWidget {
  const CrmConfigScreen({super.key});

  @override
  ConsumerState<CrmConfigScreen> createState() => _CrmConfigScreenState();
}

class _CrmConfigScreenState extends ConsumerState<CrmConfigScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración CRM'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allow scrolling on mobile for better readability
          tabs: const [
            Tab(text: 'Tipos de Reclamo'),
            Tab(text: 'Tipos de Interacción'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ClaimTypesListView(),
          InteractionTypesListView(),
        ],
      ),
    );
  }
}
