import 'package:flutter/material.dart';

/// Configuración de branding personalizado por empresa (EXPANDIDO)
class EmpresaBranding {
  final int id;
  final int empresaId;
  
  // COLORES BASE
  final String colorPrimario;
  final String colorSecundario;
  final String colorAcento;
  
  // COLORES ADICIONALES (NUEVOS)
  final String colorFondo;
  final String colorTexto;
  final String colorError;
  final String colorExito;
  final String colorAdvertencia;
  final String colorInfo;
  
  // LOGOS
  final String? logoUrl;
  final String? logoLightUrl;
  final String? faviconUrl;
  
  // TIPOGRAFÍA
  final String fuentePrimaria;
  final String fuenteSecundaria;
  final int tamanoTextoBase;
  final int tamanoHeader;
  
  // DARK MODE
  final bool darkModeHabilitado;
  final String? colorPrimarioDark;
  final String? colorSecundarioDark;
  final String? colorFondoDark;
  final String? colorTextoDark;
  final String? colorErrorDark;
  final String? colorExitoDark;
  final String? colorAdvertenciaDark;
  final String? colorInfoDark;
  
  // ESPACIADO Y BORDES
  final int espaciadoBase;
  final int radioBordes;
  
  // METADATA
  final DateTime fechaCreacion;
  final DateTime actualizadoEn;

  const EmpresaBranding({
    required this.id,
    required this.empresaId,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.colorAcento,
    this.colorFondo = '#FFFFFF',
    this.colorTexto = '#1F2937',
    this.colorError = '#EF4444',
    this.colorExito = '#10B981',
    this.colorAdvertencia = '#F59E0B',
    this.colorInfo = '#3B82F6',
    this.logoUrl,
    this.logoLightUrl,
    this.faviconUrl,
    required this.fuentePrimaria,
    this.fuenteSecundaria = 'Roboto',
    this.tamanoTextoBase = 16,
    this.tamanoHeader = 28,
    required this.darkModeHabilitado,
    this.colorPrimarioDark,
    this.colorSecundarioDark,
    this.colorFondoDark = '#1F2937',
    this.colorTextoDark = '#F9FAFB',
    this.colorErrorDark = '#F87171',
    this.colorExitoDark = '#34D399',
    this.colorAdvertenciaDark = '#FBBF24',
    this.colorInfoDark = '#60A5FA',
    this.espaciadoBase = 16,
    this.radioBordes = 8,
    required this.fechaCreacion,
    required this.actualizadoEn,
  });

  /// Convierte color hex string a Color
  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  // GETTERS DE COLORES BASE
  Color get primaryColor => _hexToColor(colorPrimario);
  Color get secondaryColor => _hexToColor(colorSecundario);
  Color get accentColor => _hexToColor(colorAcento);
  
  // GETTERS DE COLORES ADICIONALES
  Color get backgroundColor => _hexToColor(colorFondo);
  Color get textColor => _hexToColor(colorTexto);
  Color get errorColor => _hexToColor(colorError);
  Color get successColor => _hexToColor(colorExito);
  Color get warningColor => _hexToColor(colorAdvertencia);
  Color get infoColor => _hexToColor(colorInfo);

  // GETTERS DE DARK MODE
  Color? get primaryColorDark => 
      colorPrimarioDark != null ? _hexToColor(colorPrimarioDark!) : null;
  Color? get secondaryColorDark => 
      colorSecundarioDark != null ? _hexToColor(colorSecundarioDark!) : null;
  Color? get backgroundColorDark => 
      colorFondoDark != null ? _hexToColor(colorFondoDark!) : null;
  Color? get textColorDark => 
      colorTextoDark != null ? _hexToColor(colorTextoDark!) : null;
  Color? get errorColorDark => 
      colorErrorDark != null ? _hexToColor(colorErrorDark!) : null;
  Color? get successColorDark => 
      colorExitoDark != null ? _hexToColor(colorExitoDark!) : null;
  Color? get warningColorDark => 
      colorAdvertenciaDark != null ? _hexToColor(colorAdvertenciaDark!) : null;
  Color? get infoColorDark => 
      colorInfoDark != null ? _hexToColor(colorInfoDark!) : null;

  /// Genera un ThemeData completo basado en los colores de branding
  ThemeData toThemeData({bool isDark = false}) {
    final primary = isDark && primaryColorDark != null ? primaryColorDark! : primaryColor;
    final secondary = isDark && secondaryColorDark != null ? secondaryColorDark! : secondaryColor;
    final accent = accentColor;
    final background = isDark && backgroundColorDark != null ? backgroundColorDark! : backgroundColor;
    final text = isDark && textColorDark != null ? textColorDark! : textColor;
    
    // Crear ColorScheme personalizado
    final colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      onPrimary: _getContrastColor(primary),
      secondary: secondary,
      onSecondary: _getContrastColor(secondary),
      tertiary: accent,
      onTertiary: _getContrastColor(accent),
      error: isDark && errorColorDark != null ? errorColorDark! : errorColor,
      onError: Colors.white,
      surface: background,
      onSurface: text,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fuentePrimaria,
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: tamanoTextoBase.toDouble()),
        headlineMedium: TextStyle(
          fontSize: tamanoHeader.toDouble(),
          fontFamily: fuenteSecundaria,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Calcula color de contraste para texto
  Color _getContrastColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Crea desde JSON
  factory EmpresaBranding.fromJson(Map<String, dynamic> json) {
    return EmpresaBranding(
      id: json['id'] as int,
      empresaId: json['empresa_id'] as int,
      colorPrimario: json['color_primario'] as String,
      colorSecundario: json['color_secundario'] as String,
      colorAcento: json['color_acento'] as String,
      colorFondo: json['color_fondo'] as String? ?? '#FFFFFF',
      colorTexto: json['color_texto'] as String? ?? '#1F2937',
      colorError: json['color_error'] as String? ?? '#EF4444',
      colorExito: json['color_exito'] as String? ?? '#10B981',
      colorAdvertencia: json['color_advertencia'] as String? ?? '#F59E0B',
      colorInfo: json['color_info'] as String? ?? '#3B82F6',
      logoUrl: json['logo_url'] as String?,
      logoLightUrl: json['logo_light_url'] as String?,
      faviconUrl: json['favicon_url'] as String?,
      fuentePrimaria: json['fuente_primaria'] as String,
      fuenteSecundaria: json['fuente_secundaria'] as String? ?? 'Roboto',
      tamanoTextoBase: json['tamano_texto_base'] as int? ?? 16,
      tamanoHeader: json['tamano_header'] as int? ?? 28,
      darkModeHabilitado: json['dark_mode_habilitado'] as bool,
      colorPrimarioDark: json['color_primario_dark'] as String?,
      colorSecundarioDark: json['color_secundario_dark'] as String?,
      colorFondoDark: json['color_fondo_dark'] as String?,
      colorTextoDark: json['color_texto_dark'] as String?,
      colorErrorDark: json['color_error_dark'] as String?,
      colorExitoDark: json['color_exito_dark'] as String?,
      colorAdvertenciaDark: json['color_advertencia_dark'] as String?,
      colorInfoDark: json['color_info_dark'] as String?,
      espaciadoBase: json['espaciado_base'] as int? ?? 16,
      radioBordes: json['radio_bordes'] as int? ?? 8,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      actualizadoEn: DateTime.parse(json['actualizado_en'] as String),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'color_primario': colorPrimario,
      'color_secundario': colorSecundario,
      'color_acento': colorAcento,
      'color_fondo': colorFondo,
      'color_texto': colorTexto,
      'color_error': colorError,
      'color_exito': colorExito,
      'color_advertencia': colorAdvertencia,
      'color_info': colorInfo,
      'logo_url': logoUrl,
      'logo_light_url': logoLightUrl,
      'favicon_url': faviconUrl,
      'fuente_primaria': fuentePrimaria,
      'fuente_secundaria': fuenteSecundaria,
      'tamano_texto_base': tamanoTextoBase,
      'tamano_header': tamanoHeader,
      'dark_mode_habilitado': darkModeHabilitado,
      'color_primario_dark': colorPrimarioDark,
      'color_secundario_dark': colorSecundarioDark,
      'color_fondo_dark': colorFondoDark,
      'color_texto_dark': colorTextoDark,
      'color_error_dark': colorErrorDark,
      'color_exito_dark': colorExitoDark,
      'color_advertencia_dark': colorAdvertenciaDark,
      'color_info_dark': colorInfoDark,
      'espaciado_base': espaciadoBase,
      'radio_bordes': radioBordes,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'actualizado_en': actualizadoEn.toIso8601String(),
    };
  }

  /// Crea copia con modificaciones
  EmpresaBranding copyWith({
    int? id,
    int? empresaId,
    String? colorPrimario,
    String? colorSecundario,
    String? colorAcento,
    String? colorFondo,
    String? colorTexto,
    String? colorError,
    String? colorExito,
    String? colorAdvertencia,
    String? colorInfo,
    String? logoUrl,
    String? logoLightUrl,
    String? faviconUrl,
    String? fuentePrimaria,
    String? fuenteSecundaria,
    int? tamanoTextoBase,
    int? tamanoHeader,
    bool? darkModeHabilitado,
    String? colorPrimarioDark,
    String? colorSecundarioDark,
    String? colorFondoDark,
    String? colorTextoDark,
    String? colorErrorDark,
    String? colorExitoDark,
    String? colorAdvertenciaDark,
    String? colorInfoDark,
    int? espaciadoBase,
    int? radioBordes,
    DateTime? fechaCreacion,
    DateTime? actualizadoEn,
  }) {
    return EmpresaBranding(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      colorPrimario: colorPrimario ?? this.colorPrimario,
      colorSecundario: colorSecundario ?? this.colorSecundario,
      colorAcento: colorAcento ?? this.colorAcento,
      colorFondo: colorFondo ?? this.colorFondo,
      colorTexto: colorTexto ?? this.colorTexto,
      colorError: colorError ?? this.colorError,
      colorExito: colorExito ?? this.colorExito,
      colorAdvertencia: colorAdvertencia ?? this.colorAdvertencia,
      colorInfo: colorInfo ?? this.colorInfo,
      logoUrl: logoUrl ?? this.logoUrl,
      logoLightUrl: logoLightUrl ?? this.logoLightUrl,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      fuentePrimaria: fuentePrimaria ?? this.fuentePrimaria,
      fuenteSecundaria: fuenteSecundaria ?? this.fuenteSecundaria,
      tamanoTextoBase: tamanoTextoBase ?? this.tamanoTextoBase,
      tamanoHeader: tamanoHeader ?? this.tamanoHeader,
      darkModeHabilitado: darkModeHabilitado ?? this.darkModeHabilitado,
      colorPrimarioDark: colorPrimarioDark ?? this.colorPrimarioDark,
      colorSecundarioDark: colorSecundarioDark ?? this.colorSecundarioDark,
      colorFondoDark: colorFondoDark ?? this.colorFondoDark,
      colorTextoDark: colorTextoDark ?? this.colorTextoDark,
      colorErrorDark: colorErrorDark ?? this.colorErrorDark,
      colorExitoDark: colorExitoDark ?? this.colorExitoDark,
      colorAdvertenciaDark: colorAdvertenciaDark ?? this.colorAdvertenciaDark,
      colorInfoDark: colorInfoDark ?? this.colorInfoDark,
      espaciadoBase: espaciadoBase ?? this.espaciadoBase,
      radioBordes: radioBordes ?? this.radioBordes,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return 'EmpresaBranding(id: $id, empresaId: $empresaId, '
        'colors: [$colorPrimario, $colorSecundario, $colorAcento])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmpresaBranding &&
        other.id == id &&
        other.empresaId == empresaId;
  }

  @override
  int get hashCode => Object.hash(id, empresaId);
}
