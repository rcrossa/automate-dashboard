import 'package:flutter/material.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';

/// Widget de preview en tiempo real para theming
/// Muestra cómo se verán los colores aplicados
class ThemePreview extends StatelessWidget {
  final EmpresaBranding branding;
  final bool isDarkMode;

  const ThemePreview({
    super.key,
    required this.branding,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = branding.toThemeData(isDark: isDarkMode);
    
    return Theme(
      data: theme,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                'Vista Previa',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              // Botones con diferentes estados
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Primario'),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: const Text('Deshabilitado'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Secundario'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Texto'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Chips de estado
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: const Text('Error'),
                    backgroundColor: branding.errorColor,
                  ),
                  Chip(
                    label: const Text('Éxito'),
                    backgroundColor: branding.successColor,
                  ),
                  Chip(
                    label: const Text('Warning'),
                    backgroundColor: branding.warningColor,
                  ),
                  Chip(
                    label: const Text('Info'),
                    backgroundColor: branding.infoColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Texto de ejemplo
              Text(
                'Texto de ejemplo con la fuente ${branding.fuentePrimaria}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Este es un párrafo de ejemplo para mostrar cómo se verá el texto con los colores y fuentes seleccionados. Los colores de fondo y texto deben tener buen contraste para legibilidad.',
                style: TextStyle(fontSize: branding.tamanoTextoBase.toDouble()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
