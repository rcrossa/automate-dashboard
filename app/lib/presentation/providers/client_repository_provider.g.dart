// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientRepository)
const clientRepositoryProvider = ClientRepositoryProvider._();

final class ClientRepositoryProvider
    extends
        $FunctionalProvider<
          ClientRepository,
          ClientRepository,
          ClientRepository
        >
    with $Provider<ClientRepository> {
  const ClientRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClientRepository create(Ref ref) {
    return clientRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientRepository>(value),
    );
  }
}

String _$clientRepositoryHash() => r'8e502a77384426cbda8eac769efd13ac5fbd1ad2';
