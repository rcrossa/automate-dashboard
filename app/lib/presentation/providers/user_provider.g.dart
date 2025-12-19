// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserState)
const userStateProvider = UserStateProvider._();

final class UserStateProvider
    extends $AsyncNotifierProvider<UserState, UserSession> {
  const UserStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStateHash();

  @$internal
  @override
  UserState create() => UserState();
}

String _$userStateHash() => r'e608d49f071d93a4cfc7b704193bc97967e0ddf4';

abstract class _$UserState extends $AsyncNotifier<UserSession> {
  FutureOr<UserSession> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserSession>, UserSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserSession>, UserSession>,
              AsyncValue<UserSession>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
