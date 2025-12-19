import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/presentation/providers/branding_provider.dart';
import 'package:msasb_app/presentation/screens/admin/widgets/theme_preview.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/logos_tab.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/colors_base_tab.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/colors_additional_tab.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/typography_tab.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/advanced_tab.dart';
import 'package:msasb_app/utils/theme_presets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msasb_app/utils/error_handler.dart';

/// Pantalla completa para configurar branding de la empresa con tabs
class BrandingSettingsScreen extends ConsumerStatefulWidget {
  const BrandingSettingsScreen({super.key});

  @override
  ConsumerState<BrandingSettingsScreen> createState() => _BrandingSettingsScreenState();
}

class _BrandingSettingsScreenState extends ConsumerState<BrandingSettingsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Colores (light mode)
  Color? _selectedPrimaryColor;
  Color? _selectedSecondaryColor;
  Color? _selectedAccentColor;
  Color? _selectedBackgroundColor;
  Color? _selectedTextColor;
  Color? _selectedErrorColor;
  Color? _selectedSuccessColor;
  Color? _selectedWarningColor;
  Color? _selectedInfoColor;
  
  // Colores dark mode
  Color? _selectedPrimaryColorDark;
  Color? _selectedSecondaryColorDark;
  Color? _selectedBackgroundColorDark;
  Color? _selectedTextColorDark;
  Color? _selectedErrorColorDark;
  Color? _selectedSuccessColorDark;
  Color? _selectedWarningColorDark;
  Color? _selectedInfoColorDark;
  
  // Tipografía
  String? _selectedPrimaryFont;
  String? _selectedSecondaryFont;
  double? _selectedBaseTextSize;
  double? _selectedHeaderSize;
  
  // Logos
  XFile? _selectedLogo;
  XFile? _selectedLogoLight;
  
  bool _isLoading = false;
  String? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brandingAsync = ref.watch(companyBrandingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.brandingCustomization),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: const Icon(Icons.image), text: l10n.brandingTabLogos),
            Tab(icon: const Icon(Icons.palette), text: l10n.brandingTabColorsBase),
            Tab(icon: const Icon(Icons.color_lens), text: l10n.brandingTabColorsAdditional),
            Tab(icon: const Icon(Icons.text_fields), text: l10n.brandingTabTypography),
            Tab(icon: const Icon(Icons.settings), text: l10n.brandingTabAdvanced),
          ],
        ),
      ),
      body: brandingAsync.when(
        loading: () => Center(child: Text(l10n.brandingLoading)),
        error: (error, _) => Center(child: Text(l10n.brandingError(error.toString()))),
        data: (branding) {
          if (branding == null) {
            return Center(child: Text(l10n.brandingNotFound));
          }

          _initializeColors(branding);

          return Row(
            children: [
              // Contenido de tabs
              Expanded(
                flex: 2,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LogosTab(
                      branding: branding,
                      onLogoSelected: (file) => setState(() => _selectedLogo = file),
                      onLogoLightSelected: (file) => setState(() => _selectedLogoLight = file),
                    ),
                    ColorsBaseTab(
                      branding: branding,
                      primaryColor: _selectedPrimaryColor!,
                      secondaryColor: _selectedSecondaryColor!,
                      accentColor: _selectedAccentColor!,
                      primaryColorDark: _selectedPrimaryColorDark,
                      secondaryColorDark: _selectedSecondaryColorDark,
                      onPrimaryColorChanged: (c) => setState(() => _selectedPrimaryColor = c),
                      onSecondaryColorChanged: (c) => setState(() => _selectedSecondaryColor = c),
                      onAccentColorChanged: (c) => setState(() => _selectedAccentColor = c),
                      onPrimaryColorDarkChanged: (c) => setState(() => _selectedPrimaryColorDark = c),
                      onSecondaryColorDarkChanged: (c) => setState(() => _selectedSecondaryColorDark = c),
                    ),
                    ColorsAdditionalTab(
                      branding: branding,
                      backgroundColor: _selectedBackgroundColor!,
                      textColor: _selectedTextColor!,
                      errorColor: _selectedErrorColor!,
                      successColor: _selectedSuccessColor!,
                      warningColor: _selectedWarningColor!,
                      infoColor: _selectedInfoColor!,
                      backgroundColorDark: _selectedBackgroundColorDark,
                      textColorDark: _selectedTextColorDark,
                      errorColorDark: _selectedErrorColorDark,
                      successColorDark: _selectedSuccessColorDark,
                      warningColorDark: _selectedWarningColorDark,
                      infoColorDark: _selectedInfoColorDark,
                      onBackgroundColorChanged: (c) => setState(() => _selectedBackgroundColor = c),
                      onTextColorChanged: (c) => setState(() => _selectedTextColor = c),
                      onErrorColorChanged: (c) => setState(() => _selectedErrorColor = c),
                      onSuccessColorChanged: (c) => setState(() => _selectedSuccessColor = c),
                      onWarningColorChanged: (c) => setState(() => _selectedWarningColor = c),
                      onInfoColorChanged: (c) => setState(() => _selectedInfoColor = c),
                      onBackgroundColorDarkChanged: (c) => setState(() => _selectedBackgroundColorDark = c),
                      onTextColorDarkChanged: (c) => setState(() => _selectedTextColorDark = c),
                      onErrorColorDarkChanged: (c) => setState(() => _selectedErrorColorDark = c),
                      onSuccessColorDarkChanged: (c) => setState(() => _selectedSuccessColorDark = c),
                      onWarningColorDarkChanged: (c) => setState(() => _selectedWarningColorDark = c),
                      onInfoColorDarkChanged: (c) => setState(() => _selectedInfoColorDark = c),
                    ),
                    TypographyTab(
                      branding: branding,
                      primaryFont: _selectedPrimaryFont!,
                      secondaryFont: _selectedSecondaryFont!,
                      baseTextSize: _selectedBaseTextSize!,
                      headerSize: _selectedHeaderSize!,
                      onPrimaryFontChanged: (f) => setState(() => _selectedPrimaryFont = f),
                      onSecondaryFontChanged: (f) => setState(() => _selectedSecondaryFont = f),
                      onBaseTextSizeChanged: (s) => setState(() => _selectedBaseTextSize = s),
                      onHeaderSizeChanged: (s) => setState(() => _selectedHeaderSize = s),
                    ),
                    AdvancedTab(
                      branding: branding,
                      selectedPreset: _selectedPreset,
                      onResetPressed: () => _showResetDialog(branding),
                      onPresetSelected: _applyPreset,
                    ),
                  ],
                ),
              ),
              // Preview side-by-side (solo en desktop)
              if (MediaQuery.of(context).size.width >= 1200)
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vista Previa',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ThemePreview(
                          branding: _buildPreviewBranding(branding),
                          isDarkMode: false,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Vista Previa (Dark)',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ThemePreview(
                          branding: _buildPreviewBranding(branding),
                          isDarkMode: true,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  void _initializeColors(EmpresaBranding branding) {
    _selectedPrimaryColor ??= branding.primaryColor;
    _selectedSecondaryColor ??= branding.secondaryColor;
    _selectedAccentColor ??= branding.accentColor;
    _selectedBackgroundColor ??= branding.backgroundColor;
    _selectedTextColor ??= branding.textColor;
    _selectedErrorColor ??= branding.errorColor;
    _selectedSuccessColor ??= branding.successColor;
    _selectedWarningColor ??= branding.warningColor;
    _selectedInfoColor ??= branding.infoColor;
    
    _selectedPrimaryColorDark ??= branding.primaryColorDark;
    _selectedSecondaryColorDark ??= branding.secondaryColorDark;
    _selectedBackgroundColorDark ??= branding.backgroundColorDark;
    _selectedTextColorDark ??= branding.textColorDark;
    _selectedErrorColorDark ??= branding.errorColorDark;
    _selectedSuccessColorDark ??= branding.successColorDark;
    _selectedWarningColorDark ??= branding.warningColorDark;
    _selectedInfoColorDark ??= branding.infoColorDark;
    
    _selectedPrimaryFont ??= branding.fuentePrimaria;
    _selectedSecondaryFont ??= branding.fuenteSecundaria;
    _selectedBaseTextSize ??= branding.tamanoTextoBase.toDouble();
    _selectedHeaderSize ??= branding.tamanoHeader.toDouble();
  }

  EmpresaBranding _buildPreviewBranding(EmpresaBranding original) {
    return EmpresaBranding(
      id: original.id,
      empresaId: original.empresaId,
      colorPrimario: _colorToHex(_selectedPrimaryColor!),
      colorSecundario: _colorToHex(_selectedSecondaryColor!),
      colorAcento: _colorToHex(_selectedAccentColor!),
      colorFondo: _colorToHex(_selectedBackgroundColor!),
      colorTexto: _colorToHex(_selectedTextColor!),
      colorError: _colorToHex(_selectedErrorColor!),
      colorExito: _colorToHex(_selectedSuccessColor!),
      colorAdvertencia: _colorToHex(_selectedWarningColor!),
      colorInfo: _colorToHex(_selectedInfoColor!),
      logoUrl: original.logoUrl,
      logoLightUrl: original.logoLightUrl,
      faviconUrl: original.faviconUrl,
      fuentePrimaria: _selectedPrimaryFont!,
      fuenteSecundaria: _selectedSecondaryFont!,
      tamanoTextoBase: _selectedBaseTextSize!.toInt(),
      tamanoHeader: _selectedHeaderSize!.toInt(),
      darkModeHabilitado: original.darkModeHabilitado,
      colorPrimarioDark: _selectedPrimaryColorDark != null ? _colorToHex(_selectedPrimaryColorDark!) : null,
      colorSecundarioDark: _selectedSecondaryColorDark != null ? _colorToHex(_selectedSecondaryColorDark!) : null,
      colorFondoDark: _selectedBackgroundColorDark != null ? _colorToHex(_selectedBackgroundColorDark!) : null,
      colorTextoDark: _selectedTextColorDark != null ? _colorToHex(_selectedTextColorDark!) : null,
      colorErrorDark: _selectedErrorColorDark != null ? _colorToHex(_selectedErrorColorDark!) : null,
      colorExitoDark: _selectedSuccessColorDark != null ? _colorToHex(_selectedSuccessColorDark!) : null,
      colorAdvertenciaDark: _selectedWarningColorDark != null ? _colorToHex(_selectedWarningColorDark!) : null,
      colorInfoDark: _selectedInfoColorDark != null ? _colorToHex(_selectedInfoColorDark!) : null,
      fechaCreacion: original.fechaCreacion,
      actualizadoEn: DateTime.now(),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void _applyPreset(String presetName) {
    final l10n = AppLocalizations.of(context)!;
    final preset = ThemePresets.all()[presetName]!;
    
    setState(() {
      _selectedPreset = presetName;
      _selectedPrimaryColor = _hexToColor(preset['colorPrimario']!);
      _selectedSecondaryColor = _hexToColor(preset['colorSecundario']!);
      _selectedAccentColor = _hexToColor(preset['colorAcento']!);
      _selectedBackgroundColor = _hexToColor(preset['colorFondo']!);
      _selectedTextColor = _hexToColor(preset['colorTexto']!);
      _selectedErrorColor = _hexToColor(preset['colorError']!);
      _selectedSuccessColor = _hexToColor(preset['colorExito']!);
      _selectedWarningColor = _hexToColor(preset['colorAdvertencia']!);
      _selectedInfoColor = _hexToColor(preset['colorInfo']!);
      _selectedPrimaryFont = preset['fuentePrimaria'];
      _selectedSecondaryFont = preset['fuenteSecundaria'];
    });
    
    ErrorHandler.showSuccess(context, l10n.brandingPresetApplied(presetName));
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  void _showResetDialog(EmpresaBranding branding) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.brandingResetDialogTitle),
        content: Text(l10n.brandingResetDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _applyPreset('Professional');
            },
            child: Text(l10n.brandingResetDialogConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircularProgressIndicator(),
            ),
          OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveBranding,
            icon: const Icon(Icons.save),
            label: Text(l10n.brandingSaveChanges),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBranding() async {
    setState(() => _isLoading = true);
    
    try {
      final currentBrandingAsync = ref.read(companyBrandingProvider);
      final currentBranding = currentBrandingAsync.value;
      
      if (currentBranding == null) return;
      
      // Upload logos si fueron seleccionados
      String? logoUrl = currentBranding.logoUrl;
      String? logoLightUrl = currentBranding.logoLightUrl;
      
      if (_selectedLogo != null) {
        final bytes = await _selectedLogo!.readAsBytes();
        logoUrl = await ref.read(companyBrandingProvider.notifier).uploadLogo(
          currentBranding.empresaId,
          kIsWeb ? bytes : File(_selectedLogo!.path),
          isLightVersion: false,
        );
      }
      
      if (_selectedLogoLight != null) {
        final bytes = await _selectedLogoLight!.readAsBytes();
        logoLightUrl = await ref.read(companyBrandingProvider.notifier).uploadLogo(
          currentBranding.empresaId,
          kIsWeb ? bytes : File(_selectedLogoLight!.path),
          isLightVersion: true,
        );
      }
      
      // Crear branding actualizado
      final updatedBranding = EmpresaBranding(
        id: currentBranding.id,
        empresaId: currentBranding.empresaId,
        colorPrimario: _colorToHex(_selectedPrimaryColor!),
        colorSecundario: _colorToHex(_selectedSecondaryColor!),
        colorAcento: _colorToHex(_selectedAccentColor!),
        colorFondo: _colorToHex(_selectedBackgroundColor!),
        colorTexto: _colorToHex(_selectedTextColor!),
        colorError: _colorToHex(_selectedErrorColor!),
        colorExito: _colorToHex(_selectedSuccessColor!),
        colorAdvertencia: _colorToHex(_selectedWarningColor!),
        colorInfo: _colorToHex(_selectedInfoColor!),
        logoUrl: logoUrl,
        logoLightUrl: logoLightUrl,
        faviconUrl: currentBranding.faviconUrl,
        fuentePrimaria: _selectedPrimaryFont!,
        fuenteSecundaria: _selectedSecondaryFont!,
        tamanoTextoBase: _selectedBaseTextSize!.toInt(),
        tamanoHeader: _selectedHeaderSize!.toInt(),
        darkModeHabilitado: currentBranding.darkModeHabilitado,
        colorPrimarioDark: _selectedPrimaryColorDark != null ? _colorToHex(_selectedPrimaryColorDark!) : null,
        colorSecundarioDark: _selectedSecondaryColorDark != null ? _colorToHex(_selectedSecondaryColorDark!) : null,
        colorFondoDark: _selectedBackgroundColorDark != null ? _colorToHex(_selectedBackgroundColorDark!) : null,
        colorTextoDark: _selectedTextColorDark != null ? _colorToHex(_selectedTextColorDark!) : null,
        colorErrorDark: _selectedErrorColorDark != null ? _colorToHex(_selectedErrorColorDark!) : null,
        colorExitoDark: _selectedSuccessColorDark != null ? _colorToHex(_selectedSuccessColorDark!) : null,
        colorAdvertenciaDark: _selectedWarningColorDark != null ? _colorToHex(_selectedWarningColorDark!) : null,
        colorInfoDark: _selectedInfoColorDark != null ? _colorToHex(_selectedInfoColorDark!) : null,
        fechaCreacion: currentBranding.fechaCreacion,
        actualizadoEn: DateTime.now(),
      );
      
      await ref.read(companyBrandingProvider.notifier).updateBranding(updatedBranding);
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ErrorHandler.showSuccess(context, l10n.brandingSaveSuccess);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
