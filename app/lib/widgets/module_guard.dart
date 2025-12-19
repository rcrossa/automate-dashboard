import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/module_provider.dart';

class ModuleGuard extends ConsumerWidget {
  final String moduleCode;
  final Widget child;
  final Widget? fallback;

  const ModuleGuard({
    super.key,
    required this.moduleCode,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(activeModulesProvider);

    return modulesAsync.when(
      data: (activeModules) {
        if (activeModules.contains(moduleCode)) {
          return child;
        }
        return fallback ?? const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(), // O un loader opcional
      error: (err, stack) => fallback ?? const SizedBox.shrink(), // En error, asumimos inactivo
    );
  }
}
