// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider que indica si está en modo oscuro
/// (Puede ser persistido en SharedPreferences en el futuro)

@ProviderFor(DarkMode)
const darkModeProvider = DarkModeProvider._();

/// Provider que indica si está en modo oscuro
/// (Puede ser persistido en SharedPreferences en el futuro)
final class DarkModeProvider extends $NotifierProvider<DarkMode, bool> {
  /// Provider que indica si está en modo oscuro
  /// (Puede ser persistido en SharedPreferences en el futuro)
  const DarkModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkModeHash();

  @$internal
  @override
  DarkMode create() => DarkMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$darkModeHash() => r'd20e178aa3497d338fbd8863003dc857d7d47217';

/// Provider que indica si está en modo oscuro
/// (Puede ser persistido en SharedPreferences en el futuro)

abstract class _$DarkMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider del tema de la app basado en el branding de la empresa

@ProviderFor(appTheme)
const appThemeProvider = AppThemeFamily._();

/// Provider del tema de la app basado en el branding de la empresa

final class AppThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provider del tema de la app basado en el branding de la empresa
  const AppThemeProvider._({
    required AppThemeFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'appThemeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @override
  String toString() {
    return r'appThemeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    final argument = this.argument as bool;
    return appTheme(ref, isDark: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppThemeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appThemeHash() => r'611f0005b1463b3e6654a54888d57d284dacb240';

/// Provider del tema de la app basado en el branding de la empresa

final class AppThemeFamily extends $Family
    with $FunctionalFamilyOverride<ThemeData, bool> {
  const AppThemeFamily._()
    : super(
        retry: null,
        name: r'appThemeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider del tema de la app basado en el branding de la empresa

  AppThemeProvider call({bool isDark = false}) =>
      AppThemeProvider._(argument: isDark, from: this);

  @override
  String toString() => r'appThemeProvider';
}
