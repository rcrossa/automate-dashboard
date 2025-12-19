import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/color_picker_tile.dart';

/// Tab para configuración de colores base (primario, secundario, acento)
class ColorsBaseTab extends StatelessWidget {
  final EmpresaBranding branding;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color? primaryColorDark;
  final Color? secondaryColorDark;
  final ValueChanged<Color> onPrimaryColorChanged;
  final ValueChanged<Color> onSecondaryColorChanged;
  final ValueChanged<Color> onAccentColorChanged;
  final ValueChanged<Color> onPrimaryColorDarkChanged;
  final ValueChanged<Color> onSecondaryColorDarkChanged;

  const ColorsBaseTab({
    super.key,
    required this.branding,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.primaryColorDark,
    required this.secondaryColorDark,
    required this.onPrimaryColorChanged,
    required this.onSecondaryColorChanged,
    required this.onAccentColorChanged,
    required this.onPrimaryColorDarkChanged,
    required this.onSecondaryColorDarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.brandingColorsBaseTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.brandingColorsBaseSubtitle,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          ColorPickerTile(
            label: l10n.brandingColorPrimary,
            color: primaryColor,
            onColorChanged: onPrimaryColorChanged,
          ),
          const SizedBox(height: 16),
          
          ColorPickerTile(
            label: l10n.brandingColorSecondary,
            color: secondaryColor,
            onColorChanged: onSecondaryColorChanged,
          ),
          const SizedBox(height: 16),
          
          ColorPickerTile(
            label: l10n.brandingColorAccent,
            color: accentColor,
            onColorChanged: onAccentColorChanged,
          ),
          
          const Divider(height: 48),
          
          Text(
            l10n.brandingDarkMode,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ColorPickerTile(
            label: l10n.brandingColorPrimaryDark,
            color: primaryColorDark ?? primaryColor,
            onColorChanged: onPrimaryColorDarkChanged,
          ),
          const SizedBox(height: 16),
          
          ColorPickerTile(
            label: l10n.brandingColorSecondaryDark,
            color: secondaryColorDark ?? secondaryColor,
            onColorChanged: onSecondaryColorDarkChanged,
          ),
        ],
      ),
    );
  }
}
