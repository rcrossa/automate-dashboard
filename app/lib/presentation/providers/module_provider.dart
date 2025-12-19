import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'module_repository_provider.dart';
import 'user_provider.dart';

part 'module_provider.g.dart';

// Stream que escucha cambios en tiempo real de módulos por SUCURSAL
final moduleUpdateStreamProvider = StreamProvider<DateTime>((ref) {
  final userState = ref.watch(userStateProvider);
  final session = userState.asData?.value;

  if (session == null || session.sucursal == null) {
    return const Stream.empty();
  }

  // Single-tenant: Escuchamos cambios en 'sucursal_modulos' 
  return Supabase.instance.client
      .from('sucursal_modulos')
      .stream(primaryKey: ['id'])
      .eq('sucursal_id', session.sucursal!.id)
      .map((data) {
        return DateTime.now(); 
      });
});

@Riverpod(keepAlive: true)
class ActiveModules extends _$ActiveModules {
  @override
  FutureOr<List<String>> build() async {
    // Suscribirse a cambios en tiempo real
    ref.watch(moduleUpdateStreamProvider);

    // Escuchar cambios en la sesión
    final userState = ref.watch(userStateProvider);
    final session = userState.asData?.value;

    if (session == null) {
      return [];
    }

    // Single-tenant: No hay super_admin multi-empresa
    // Admin tiene acceso a todos los módulos configurables
    if (session.currentRole == 'admin') {
      // Return all available modules for admin
      return ['dashboard', 'reclamos', 'clientes', 'personal', 'sucursales', 'crm_interacciones', 'reportes'];
    }

    // Usuarios regulares: verificar módulos activos por sucursal
    if (session.sucursal == null) {
      // Sin sucursal asignada, acceso limitado
      return ['dashboard'];
    }

    final repo = ref.read(moduleRepositoryProvider);
    // Consultar módulos activos para la sucursal actual
    final result = await repo.getBranchModules(
      branchId: session.sucursal!.id,
    );
    return result;
  }
}
