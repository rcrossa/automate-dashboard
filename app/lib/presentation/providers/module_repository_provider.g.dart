// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moduleRepository)
const moduleRepositoryProvider = ModuleRepositoryProvider._();

final class ModuleRepositoryProvider
    extends
        $FunctionalProvider<
          ModuleRepository,
          ModuleRepository,
          ModuleRepository
        >
    with $Provider<ModuleRepository> {
  const ModuleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moduleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<ModuleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ModuleRepository create(Ref ref) {
    return moduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModuleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModuleRepository>(value),
    );
  }
}

String _$moduleRepositoryHash() => r'cfc689536a4ee64750ec5686dcaf4f715165160a';
