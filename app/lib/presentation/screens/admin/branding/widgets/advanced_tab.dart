import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/utils/theme_presets.dart';

/// Tab avanzado con presets e información del branding
class AdvancedTab extends StatelessWidget {
  final EmpresaBranding branding;
  final String? selectedPreset;
  final VoidCallback onResetPressed;
  final ValueChanged<String> onPresetSelected;

  const AdvancedTab({
    super.key,
    required this.branding,
    required this.selectedPreset,
    required this.onResetPressed,
    required this.onPresetSelected,
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
            l10n.brandingAdvancedTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.brandingAdvancedSubtitle,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          Text(l10n.brandingPresets, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          Text(
            l10n.brandingPresetsSubtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          
          // Dropdown de presets
          DropdownButtonFormField<String>(
            value: selectedPreset,
            decoration: InputDecoration(
              labelText: l10n.brandingPresetSelect,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.brandingPresetNone)),
              ...ThemePresets.names().map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }),
            ],
            onChanged: (value) {
              if (value != null && value != selectedPreset) {
                onPresetSelected(value);
              }
            },
          ),
          const SizedBox(height: 24),
          
          // Botón reset
          OutlinedButton.icon(
            onPressed: onResetPressed,
            icon: const Icon(Icons.restore),
            label: Text(l10n.brandingResetDefaults),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          
          const Divider(height: 48),
          
          Text(l10n.brandingInfo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.brandingLastUpdated(_formatDate(branding.actualizadoEn))),
                  const SizedBox(height: 8),
                  Text(l10n.brandingCreated(_formatDate(branding.fechaCreacion))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
