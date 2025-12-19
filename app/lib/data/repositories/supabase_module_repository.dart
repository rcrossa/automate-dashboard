import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/module_repository.dart';

class SupabaseModuleRepository implements ModuleRepository {
  final SupabaseClient _client;

  SupabaseModuleRepository(this._client);

  @override
  Future<List<Map<String, dynamic>>> getModules() async {
    try {
      return await _client
          .from('modulos')
          .select()
          .eq('activo', true)
          .order('nombre');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<String>> getActiveModules({required int? companyId, int? branchId}) async {
    if (companyId == null) return [];

    try {
      // 1. Nivel Empresa
      final rawResp = await _client
          .from('empresa_modulos')
          .select('*, modulos(codigo)')
          .eq('empresa_id', companyId);
      

      final empresaResp = (rawResp as List)
          .where((e) => e['activo'] == true)
          .toList();

      final codigos = empresaResp
          .map((e) => e['modulos']['codigo'] as String)
          .toSet();

      // 2. Nivel Sucursal (si hay sucursal)
      if (branchId != null) {
        final sucursalResp = await _client
            .from('sucursal_modulos')
            .select('modulo_codigo')
            .eq('sucursal_id', branchId)
            .eq('activo', true);
        
        for (var item in sucursalResp) {
          codigos.add(item['modulo_codigo'] as String);
        }
      }

      // 3. Nivel Usuario (si hay usuario logueado)
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        final usuarioResp = await _client
            .from('usuario_modulos')
            .select('modulo_codigo')
            .eq('usuario_id', userId)
            .eq('activo', true);

        for (var item in usuarioResp) {
          codigos.add(item['modulo_codigo'] as String);
        }
      }

      return codigos.toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> toggleCompanyModule({required int companyId, required int moduleId, required bool isActive}) async {
    try {
      if (isActive) {
        await _client.from('empresa_modulos').upsert({
          'empresa_id': companyId,
          'modulo_id': moduleId,
          'activo': true,
          'fecha_activacion': DateTime.now().toIso8601String(),
        }, onConflict: 'empresa_id, modulo_id');
      } else {
        await _client.from('empresa_modulos').update({
          'activo': false,
        }).eq('empresa_id', companyId).eq('modulo_id', moduleId);
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<String>> getBranchModules({required int branchId}) async {
    try {
      final response = await _client
          .from('sucursal_modulos')
          .select('modulo_codigo')
          .eq('sucursal_id', branchId)
          .eq('activo', true);
      
      return (response as List).map((e) => e['modulo_codigo'] as String).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> toggleBranchModule({
    required int branchId,
    required String moduleCode,
    required bool isActive,
    double? customPrice,
  }) async {
    try {
      if (isActive) {
        await _client.from('sucursal_modulos').upsert({
          'sucursal_id': branchId,
          'modulo_codigo': moduleCode,
          'activo': true,
          'precio_personalizado': customPrice,
          'fecha_activacion': DateTime.now().toIso8601String(),
        }, onConflict: 'sucursal_id, modulo_codigo');
      } else {
        await _client.from('sucursal_modulos').update({
          'activo': false,
        }).eq('sucursal_id', branchId).eq('modulo_codigo', moduleCode);
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<String>> getUserModules({required String userId}) async {
    try {
      final response = await _client
          .from('usuario_modulos')
          .select('modulo_codigo')
          .eq('usuario_id', userId)
          .eq('activo', true);
      
      return (response as List).map((e) => e['modulo_codigo'] as String).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> toggleUserModule({
    required String userId,
    required String moduleCode,
    required bool isActive,
    double? customPrice,
  }) async {
    try {
      if (isActive) {
        await _client.from('usuario_modulos').upsert({
          'usuario_id': userId,
          'modulo_codigo': moduleCode,
          'activo': true,
          'precio_personalizado': customPrice,
          'fecha_activacion': DateTime.now().toIso8601String(),
        }, onConflict: 'usuario_id, modulo_codigo');
      } else {
        await _client.from('usuario_modulos').update({
          'activo': false,
        }).eq('usuario_id', userId).eq('modulo_codigo', moduleCode);
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
