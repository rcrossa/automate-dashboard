// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcripcion_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transcripcionRepository)
const transcripcionRepositoryProvider = TranscripcionRepositoryProvider._();

final class TranscripcionRepositoryProvider
    extends
        $FunctionalProvider<
          TranscripcionRepository,
          TranscripcionRepository,
          TranscripcionRepository
        >
    with $Provider<TranscripcionRepository> {
  const TranscripcionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transcripcionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transcripcionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TranscripcionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TranscripcionRepository create(Ref ref) {
    return transcripcionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranscripcionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranscripcionRepository>(value),
    );
  }
}

String _$transcripcionRepositoryHash() =>
    r'6dc904072453d2659efa7c1bd6b59b26ddaaa377';
