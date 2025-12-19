// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveModules)
const activeModulesProvider = ActiveModulesProvider._();

final class ActiveModulesProvider
    extends $AsyncNotifierProvider<ActiveModules, List<String>> {
  const ActiveModulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeModulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeModulesHash();

  @$internal
  @override
  ActiveModules create() => ActiveModules();
}

String _$activeModulesHash() => r'd6714785ebab1dced102747b8a715596f0b76706';

abstract class _$ActiveModules extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
