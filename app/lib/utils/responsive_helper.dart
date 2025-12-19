import 'package:flutter/material.dart';

/// Helper centralizado para diseño responsive
/// 
/// Implementa breakpoints Material Design:
/// - Mobile: < 600px (smartphones)
/// - Tablet: 600px - 1200px (tablets, laptops pequeñas)
/// - Desktop: >= 1200px (monitores grandes)
/// 
/// Ejemplo de uso:
/// ```dart
/// if (ResponsiveHelper.isMobile(context)) {
///   return MobileLayout();
/// } else {
///   return DesktopLayout();
/// }
/// ```
class ResponsiveHelper {
  // Breakpoints Material Design - Estándar de la industria
  static const double mobileBreakpoint = 600;   // Smartphones
  static const double tabletBreakpoint = 1200;  // Tablets e híbridos
  
  /// Detecta si el dispositivo es mobile (< 600px)
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < mobileBreakpoint;
  
  /// Detecta si el dispositivo es tablet (600px - 1200px)
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= mobileBreakpoint && 
      MediaQuery.of(context).size.width < tabletBreakpoint;
  
  /// Detecta si el dispositivo es desktop (>= 1200px)
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= tabletBreakpoint;
  
  /// Retorna padding adaptativo según el tamaño de pantalla
  /// 
  /// - Mobile: 16px (compacto)
  /// - Tablet: 24px (medio)
  /// - Desktop: 32px (espacioso)
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }
  
  /// Retorna número de columnas para grids según tamaño
  /// 
  /// - Mobile: 2 columnas
  /// - Tablet: 3 columnas  
  /// - Desktop: 4 columnas
  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
  
  /// Retorna ancho máximo para contenido centrado
  /// 
  /// Evita que formularios/textos se estiren demasiado en pantallas grandes
  /// 
  /// - Mobile: Sin límite (usa todo el ancho)
  /// - Tablet: 900px
  /// - Desktop: 1200px
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 900;
    return double.infinity;
  }
}
