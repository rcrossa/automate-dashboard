// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interactionRepository)
const interactionRepositoryProvider = InteractionRepositoryProvider._();

final class InteractionRepositoryProvider
    extends
        $FunctionalProvider<
          InteractionRepository,
          InteractionRepository,
          InteractionRepository
        >
    with $Provider<InteractionRepository> {
  const InteractionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<InteractionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InteractionRepository create(Ref ref) {
    return interactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InteractionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InteractionRepository>(value),
    );
  }
}

String _$interactionRepositoryHash() =>
    r'0bc1c29884d6cf8bb081e4e8c2739bbda8d16f2b';
