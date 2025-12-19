// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that exposes current session data

@ProviderFor(session)
const sessionProvider = SessionProvider._();

/// Provider that exposes current session data

final class SessionProvider
    extends $FunctionalProvider<SessionData?, SessionData?, SessionData?>
    with $Provider<SessionData?> {
  /// Provider that exposes current session data
  const SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  $ProviderElement<SessionData?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionData? create(Ref ref) {
    return session(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionData?>(value),
    );
  }
}

String _$sessionHash() => r'1725f62805a7504fbd6ccf77d55d99a14a1f1467';
