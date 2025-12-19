
/// Presets predefinidos de theming para facilitar inicio rápido
class ThemePresets {
  // Professional - Azul y gris
  static Map<String, String> professional() {
    return {
      'colorPrimario': '#2563EB',
      'colorSecundario': '#64748B',
      'colorAcento': '#0EA5E9',
      'colorFondo': '#FFFFFF',
      'colorTexto': '#1E293B',
      'colorError': '#EF4444',
      'colorExito': '#10B981',
      'colorAdvertencia': '#F59E0B',
      'colorInfo': '#3B82F6',
      'fuentePrimaria': 'Roboto',
      'fuenteSecundaria': 'Roboto',
    };
  }
  
  // Modern - Morado y cyan
  static Map<String, String> modern() {
    return {
      'colorPrimario': '#8B5CF6',
      'colorSecundario': '#06B6D4',
      'colorAcento': '#EC4899',
      'colorFondo': '#FFFFFF',
      'colorTexto': '#1F2937',
      'colorError': '#F43F5E',
      'colorExito': '#10B981',
      'colorAdvertencia': '#F59E0B',
      'colorInfo': '#3B82F6',
      'fuentePrimaria': 'Inter',
      'fuenteSecundaria': 'Inter',
    };
  }
  
  // Minimal - Blanco y negro
  static Map<String, String> minimal() {
    return {
      'colorPrimario': '#18181B',
      'colorSecundario': '#71717A',
      'colorAcento': '#A1A1AA',
      'colorFondo': '#FFFFFF',
      'colorTexto': '#09090B',
      'colorError': '#DC2626',
      'colorExito': '#16A34A',
      'colorAdvertencia': '#CA8A04',
      'colorInfo': '#2563EB',
      'fuentePrimaria': 'Helvetica',
      'fuenteSecundaria': 'Helvetica',
    };
  }
  
  // Colorful - Vibrante
  static Map<String, String> colorful() {
    return {
      'colorPrimario': '#F59E0B',
      'colorSecundario': '#8B5CF6',
      'colorAcento': '#EC4899',
      'colorFondo': '#FEF3C7',
      'colorTexto': '#78350F',
      'colorError': '#DC2626',
      'colorExito': '#059669',
      'colorAdvertencia': '#D97706',
      'colorInfo': '#2563EB',
      'fuentePrimaria': 'Outfit',
      'fuenteSecundaria': 'Outfit',
    };
  }
  
  // Dark - Tema oscuro por defecto
  static Map<String, String> dark() {
    return {
      'colorPrimario': '#60A5FA',
      'colorSecundario': '#818CF8',
      'colorAcento': '#F472B6',
      'colorFondo': '#1F2937',
      'colorTexto': '#F9FAFB',
      'colorError': '#F87171',
      'colorExito': '#34D399',
      'colorAdvertencia': '#FBBF24',
      'colorInfo': '#60A5FA',
      'fuentePrimaria': 'Roboto',
      'fuenteSecundaria': 'Roboto',
    };
  }
  
  /// Lista de todos los presets
  static Map<String, Map<String, String>> all() {
    return {
      'Professional': professional(),
      'Modern': modern(),
      'Minimal': minimal(),
      'Colorful': colorful(),
      'Dark': dark(),
    };
  }
  
  /// Nombres de presets disponibles
  static List<String> names() {
    return ['Professional', 'Modern', 'Minimal', 'Colorful', 'Dark'];
  }
}
