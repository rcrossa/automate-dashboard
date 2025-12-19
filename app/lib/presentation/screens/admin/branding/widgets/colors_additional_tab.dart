import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/presentation/screens/admin/branding/widgets/color_picker_tile.dart';

/// Tab para colores adicionales (fondo, texto, estados) y sus versiones dark
class ColorsAdditionalTab extends StatelessWidget {
  final EmpresaBranding branding;
  final Color backgroundColor;
  final Color textColor;
  final Color errorColor;
  final Color successColor;
  final Color warningColor;
  final Color infoColor;
  final Color? backgroundColorDark;
  final Color? textColorDark;
  final Color? errorColorDark;
  final Color? successColorDark;
  final Color? warningColorDark;
  final Color? infoColorDark;
  final ValueChanged<Color> onBackgroundColorChanged;
  final ValueChanged<Color> onTextColorChanged;
  final ValueChanged<Color> onErrorColorChanged;
  final ValueChanged<Color> onSuccessColorChanged;
  final ValueChanged<Color> onWarningColorChanged;
  final ValueChanged<Color> onInfoColorChanged;
  final ValueChanged<Color> onBackgroundColorDarkChanged;
  final ValueChanged<Color> onTextColorDarkChanged;
  final ValueChanged<Color> onErrorColorDarkChanged;
  final ValueChanged<Color> onSuccessColorDarkChanged;
  final ValueChanged<Color> onWarningColorDarkChanged;
  final ValueChanged<Color> onInfoColorDarkChanged;

  const ColorsAdditionalTab({
    super.key,
    required this.branding,
    required this.backgroundColor,
    required this.textColor,
    required this.errorColor,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.backgroundColorDark,
    required this.textColorDark,
    required this.errorColorDark,
    required this.successColorDark,
    required this.warningColorDark,
    required this.infoColorDark,
    required this.onBackgroundColorChanged,
    required this.onTextColorChanged,
    required this.onErrorColorChanged,
    required this.onSuccessColorChanged,
    required this.onWarningColorChanged,
    required this.onInfoColorChanged,
    required this.onBackgroundColorDarkChanged,
    required this.onTextColorDarkChanged,
    required this.onErrorColorDarkChanged,
    required this.onSuccessColorDarkChanged,
    required this.onWarningColorDarkChanged,
    required this.onInfoColorDarkChanged,
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
            l10n.brandingColorsAdditionalTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.brandingColorsAdditionalSubtitle,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          // Colores generales
          Text(l10n.brandingColorsGeneral, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          ColorPickerTile(label: l10n.brandingColorBackground, color: backgroundColor, onColorChanged: onBackgroundColorChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorText, color: textColor, onColorChanged: onTextColorChanged),
          
          const Divider(height: 48),
          
          // Colores de estado
          Text(l10n.brandingColorsStates, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          ColorPickerTile(label: l10n.brandingColorError, color: errorColor, onColorChanged: onErrorColorChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorSuccess, color: successColor, onColorChanged: onSuccessColorChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorWarning, color: warningColor, onColorChanged: onWarningColorChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorInfo, color: infoColor, onColorChanged: onInfoColorChanged),
          
          const Divider(height: 48),
          
          // Dark mode
          Text(l10n.brandingDarkMode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          ColorPickerTile(label: l10n.brandingColorBackgroundDark, color: backgroundColorDark ?? const Color(0xFF1F2937), onColorChanged: onBackgroundColorDarkChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorTextDark, color: textColorDark ?? const Color(0xFFF9FAFB), onColorChanged: onTextColorDarkChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorErrorDark, color: errorColorDark ?? const Color(0xFFF87171), onColorChanged: onErrorColorDarkChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorSuccessDark, color: successColorDark ?? const Color(0xFF34D399), onColorChanged: onSuccessColorDarkChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorWarningDark, color: warningColorDark ?? const Color(0xFFFBBF24), onColorChanged: onWarningColorDarkChanged),
          const SizedBox(height: 16),
          ColorPickerTile(label: l10n.brandingColorInfoDark, color: infoColorDark ?? const Color(0xFF60A5FA), onColorChanged: onInfoColorDarkChanged),
        ],
      ),
    );
  }
}
