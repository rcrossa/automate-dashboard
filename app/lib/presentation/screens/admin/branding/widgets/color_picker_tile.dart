import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

/// Tile reutilizable para seleccionar colores con preview y dialog
class ColorPickerTile extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerTile({
    super.key,
    required this.label,
    required  this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_colorToHex(color)),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showColorPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color tempColor = color;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.brandingSelectColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (pickedColor) => tempColor = pickedColor,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              onColorChanged(tempColor);
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.brandingSelectColorButton),
          ),
        ],
      ),
    );
  }
}
