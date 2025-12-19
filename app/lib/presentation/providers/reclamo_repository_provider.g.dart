// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reclamo_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reclamoRepository)
const reclamoRepositoryProvider = ReclamoRepositoryProvider._();

final class ReclamoRepositoryProvider
    extends
        $FunctionalProvider<
          ReclamoRepository,
          ReclamoRepository,
          ReclamoRepository
        >
    with $Provider<ReclamoRepository> {
  const ReclamoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reclamoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reclamoRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReclamoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReclamoRepository create(Ref ref) {
    return reclamoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReclamoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReclamoRepository>(value),
    );
  }
}

String _$reclamoRepositoryHash() => r'55c27b1b3a9618b7281a8c378e98d98bd206e3b5';
