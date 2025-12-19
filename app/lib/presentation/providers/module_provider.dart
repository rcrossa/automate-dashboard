import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'module_repository_provider.dart';
import 'user_provider.dart';

part 'module_provider.g.dart';

// Stream que escucha cambios en tiempo real y emite un valor único para forzar reconstrucción
final moduleUpdateStreamProvider = StreamProvider<DateTime>((ref) {
  final userState = ref.watch(userStateProvider);
  final session = userState.asData?.value;

  if (session == null || session.empresa == null) {
    return const Stream.empty();
  }

  // Escuchamos cambios en la tabla 'empresa_modulos' filtrando por nuestra empresa
  return Supabase.instance.client
      .from('empresa_modulos')
      .stream(primaryKey: ['id'])
      .eq('empresa_id', session.empresa!.id)
      .map((data) {
        // Retornamos fecha actual para asegurar que Riverpod detecte un cambio de estado
        return DateTime.now(); 
      });
});

@Riverpod(keepAlive: true)
class ActiveModules extends _$ActiveModules {
  @override
  FutureOr<List<String>> build() async {
    // Suscribirse a cambios en tiempo real para invalidar el cache
    ref.watch(moduleUpdateStreamProvider);

    // Escuchar cambios en la sesión (empresa/sucursal)
    final userState = ref.watch(userStateProvider);
    final session = userState.asData?.value;

    if (session == null) {
      return [];
    }

    // CRITICAL: Super admin has full access to ALL modules, empresa can be null
    if (session.isSuperAdmin || session.currentRole == 'super_admin') {
      // Return all available modules for super admin
      return ['dashboard', 'reclamos', 'clientes', 'inventario', 'crm_interacciones'];
    }

    // Regular users require empresa
    if (session.empresa == null) {
      return [];
    }

    final repo = ref.read(moduleRepositoryProvider);
    // Consultar módulos activos para la empresa/sucursal actual
    final result = await repo.getActiveModules(
      companyId: session.empresa!.id,
      branchId: session.sucursal?.id,
    );
    return result;
  }
}
