// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_config_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(crmConfigRepository)
const crmConfigRepositoryProvider = CrmConfigRepositoryProvider._();

final class CrmConfigRepositoryProvider
    extends
        $FunctionalProvider<
          CrmConfigRepository,
          CrmConfigRepository,
          CrmConfigRepository
        >
    with $Provider<CrmConfigRepository> {
  const CrmConfigRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crmConfigRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crmConfigRepositoryHash();

  @$internal
  @override
  $ProviderElement<CrmConfigRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CrmConfigRepository create(Ref ref) {
    return crmConfigRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrmConfigRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrmConfigRepository>(value),
    );
  }
}

String _$crmConfigRepositoryHash() =>
    r'f010ee518a26fb4f352047a5d84b9dc634bc8a02';
