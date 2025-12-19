// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider del repository de branding

@ProviderFor(brandingRepository)
const brandingRepositoryProvider = BrandingRepositoryProvider._();

/// Provider del repository de branding

final class BrandingRepositoryProvider
    extends
        $FunctionalProvider<
          BrandingRepository,
          BrandingRepository,
          BrandingRepository
        >
    with $Provider<BrandingRepository> {
  /// Provider del repository de branding
  const BrandingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrandingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrandingRepository create(Ref ref) {
    return brandingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandingRepository>(value),
    );
  }
}

String _$brandingRepositoryHash() =>
    r'806e61dbc38303c680c9e45fab10cb57c0b19c4d';

/// Provider del branding de la empresa actual

@ProviderFor(CompanyBranding)
const companyBrandingProvider = CompanyBrandingProvider._();

/// Provider del branding de la empresa actual
final class CompanyBrandingProvider
    extends $AsyncNotifierProvider<CompanyBranding, EmpresaBranding?> {
  /// Provider del branding de la empresa actual
  const CompanyBrandingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyBrandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyBrandingHash();

  @$internal
  @override
  CompanyBranding create() => CompanyBranding();
}

String _$companyBrandingHash() => r'163477583c1f3a722085844c4da2b6065ec38b0d';

/// Provider del branding de la empresa actual

abstract class _$CompanyBranding extends $AsyncNotifier<EmpresaBranding?> {
  FutureOr<EmpresaBranding?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EmpresaBranding?>, EmpresaBranding?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EmpresaBranding?>, EmpresaBranding?>,
              AsyncValue<EmpresaBranding?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
