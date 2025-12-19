import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/module_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';


import 'widgets/granular_config_dialog.dart';
import 'widgets/module_card.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/responsive_helper.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/utils/error_handler.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  final int? empresaId; // Si es null, usa la del contexto (Company Admin). Si tiene valor, es Super Admin gestionando.

  const MarketplaceScreen({super.key, this.empresaId});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {

  List<Map<String, dynamic>> _modulos = [];
  List<String> _modulosActivos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    // Post-frame callback to ensure provider is ready if needed, though initState is fine for read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    if (!mounted) return;
    setState(() => _cargando = true);
    
    final session = ref.read(userStateProvider).asData?.value;
    final targetEmpresaId = widget.empresaId ?? session?.empresa?.id;

    if (targetEmpresaId == null) {
       if (mounted) {
        setState(() => _cargando = false);
        final l10n = AppLocalizations.of(context)!;
        ErrorHandler.showError(context, l10n.errorNoCompanyContext);
       }
       return;
    }

    try {
      final repo = ref.read(moduleRepositoryProvider);
      final modulos = await repo.getModules();
      final activos = await repo.getActiveModules(companyId: targetEmpresaId);
      if (mounted) {
        setState(() {
          _modulos = modulos;
          _modulosActivos = activos;
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

  Future<void> _toggleModulo(int id, String codigo, bool activar) async {
    final session = ref.read(userStateProvider).asData?.value;
    final targetEmpresaId = widget.empresaId ?? session?.empresa?.id;
    
    if (targetEmpresaId == null) return;

    try {
      final repo = ref.read(moduleRepositoryProvider);
      await repo.toggleCompanyModule(
        companyId: targetEmpresaId,
        moduleId: id,
        isActive: activar,
      );
      await _cargarDatos(); // Recargar estado
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  void _mostrarConfiguracionGranular(Map<String, dynamic> modulo) {
    final session = ref.read(userStateProvider).asData?.value;
    final targetEmpresaId = widget.empresaId ?? session?.empresa?.id;

    if (targetEmpresaId == null) return;

    showDialog(
      context: context,
      builder: (context) => GranularConfigDialog(
        modulo: modulo,
        empresaId: targetEmpresaId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aspect ratio responsivo para evitar overflow en diferentes breakpoints
    double aspectRatio;
    if (ResponsiveHelper.isDesktop(context)) {
      aspectRatio = 1.3; // Desktop: 4 columnas
    } else if (ResponsiveHelper.isTablet(context)) {
      aspectRatio = 1.1; // Tablet: 3 columnas (más altura para evitar overflow 600-700px)
    } else {
      aspectRatio = 1.25; // Mobile: 2 columnas
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.marketplaceTitle),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: _cargando
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
              childAspectRatio: aspectRatio, // Aspect ratio responsivo
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
            itemCount: _modulos.length,
            itemBuilder: (context, index) => _buildModuleCardWrapper(_modulos[index]),
          ),
    );
  }

  Widget _buildModuleCardWrapper(Map<String, dynamic> mod) {
    final codigo = mod['codigo'];
    final esActivo = _modulosActivos.contains(codigo);
    
    return ModuleCard(
      moduleData: mod,
      isActive: esActivo,
      onToggle: (val) => _toggleModulo(mod['id'], codigo, val),
      onConfigure: () => _mostrarConfiguracionGranular(mod),
    );
  }
}