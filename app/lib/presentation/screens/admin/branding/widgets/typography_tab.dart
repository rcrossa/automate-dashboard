import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';

/// Tab para configuración de tipografía (fuentes y tamaños)
class TypographyTab extends StatelessWidget {
  final EmpresaBranding branding;
  final String primaryFont;
  final String secondaryFont;
  final double baseTextSize;
  final double headerSize;
  final ValueChanged<String> onPrimaryFontChanged;
  final ValueChanged<String> onSecondaryFontChanged;
  final ValueChanged<double> onBaseTextSizeChanged;
  final ValueChanged<double> onHeaderSizeChanged;

  const TypographyTab({
    super.key,
    required this.branding,
    required this.primaryFont,
    required this.secondaryFont,
    required this.baseTextSize,
    required this.headerSize,
    required this.onPrimaryFontChanged,
    required this.onSecondaryFontChanged,
    required this.onBaseTextSizeChanged,
    required this.onHeaderSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availableFonts = ['Roboto', 'Inter', 'Outfit', 'Helvetica', 'Arial', 'Times New Roman', 'Georgia'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.brandingTypographyTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.brandingTypographySubtitle,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          Text(l10n.brandingFonts, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          // Fuente primaria
          ListTile(
            title: Text(l10n.brandingFontPrimary),
            subtitle: Text(primaryFont),
            trailing: DropdownButton<String>(
              value: primaryFont,
              items: availableFonts.map((font) {
                return DropdownMenuItem(value: font, child: Text(font, style: TextStyle(fontFamily: font)));
              }).toList(),
              onChanged: (value) {
                if (value != null) onPrimaryFontChanged(value);
              },
            ),
          ),
          
          // Preview fuente primaria
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'El veloz murciélago hindú comía feliz cardillo y kiwi. 1234567890',
              style: TextStyle(fontFamily: primaryFont, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          
          // Fuente secundaria
          ListTile(
            title: Text(l10n.brandingFontSecondary),
            subtitle: Text(secondaryFont),
            trailing: DropdownButton<String>(
              value: secondaryFont,
              items: availableFonts.map((font) {
                return DropdownMenuItem(value: font, child: Text(font, style: TextStyle(fontFamily: font)));
              }).toList(),
              onChanged: (value) {
                if (value != null) onSecondaryFontChanged(value);
              },
            ),
          ),
          
          // Preview fuente secundaria
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Título de Ejemplo 123',
              style: TextStyle(fontFamily: secondaryFont, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          const Divider(height: 48),
          
          Text(l10n.brandingSizes, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          // Tamaño texto base
          ListTile(
            title: Text(l10n.brandingTextSizeBase(baseTextSize.toInt())),
            subtitle: Slider(
              value: baseTextSize,
              min: 12,
              max: 20,
              divisions: 8,
              label: '${baseTextSize.toInt()}px',
              onChanged: onBaseTextSizeChanged,
            ),
          ),
          
          // Preview tamaño base
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.brandingTextSizeExample(baseTextSize.toInt()),
              style: TextStyle(fontSize: baseTextSize),
            ),
          ),
          const SizedBox(height: 24),
          
          // Tamaño header
          ListTile(
            title: Text(l10n.brandingTextSizeHeader(headerSize.toInt())),
            subtitle: Slider(
              value: headerSize,
              min: 20,
              max: 36,
              divisions: 16,
              label: '${headerSize.toInt()}px',
              onChanged: onHeaderSizeChanged,
            ),
          ),
          
          // Preview tamaño header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.brandingHeaderExample,
              style: TextStyle(fontSize: headerSize, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
