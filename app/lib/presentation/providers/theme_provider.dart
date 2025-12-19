import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:msasb_app/presentation/providers/branding_provider.dart';

part 'theme_provider.g.dart';

/// Provider que indica si está en modo oscuro
/// (Puede ser persistido en SharedPreferences en el futuro)
@riverpod
class DarkMode extends _$DarkMode {
  @override
  bool build() {
    // Por defecto usar el tema del sistema
    return false;
  }

  void toggle() {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}

/// Provider del tema de la app basado en el branding de la empresa
@riverpod
ThemeData appTheme(Ref ref, {bool isDark = false}) {
  final branding = ref.watch(companyBrandingProvider).value;

  if (branding == null) {
    // Tema por defecto si no hay branding
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  // Usar el branding personalizado
  return branding.toThemeData(isDark: isDark);
}
