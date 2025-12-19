import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/user_repository.dart';

class SupabaseUserRepository implements UserRepository {
  final SupabaseClient _client;

  SupabaseUserRepository(this._client);

  @override
  Future<List<dynamic>> getUsers() async {
    try {
      final resp = await _client
        .from('usuarios')
        .select('id, email, nombre, username, tipo_perfil, rol_id');
      return resp;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<dynamic>> getRoles() async {
    try {
      final resp = await _client
        .from('roles')
        .select('id, nombre');
      return resp;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<dynamic>> getPermissions() async {
    try {
      final resp = await _client
        .from('permisos')
        .select('id, nombre, descripcion');
      return resp;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<int>> getUserPermissions(String userId) async {
    try {
      final resp = await _client
        .from('usuario_permiso')
        .select('permiso_id')
        .eq('usuario_id', userId);
      return (resp as List?)?.map((e) => e['permiso_id'] as int).toList() ?? [];
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> changeUserRole(String userId, int newRoleId) async {
    try {
      await _client
        .from('usuarios')
        .update({'rol_id': newRoleId})
        .eq('id', userId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> assignPermission(String userId, int permissionId) async {
    try {
      await _client
        .from('usuario_permiso')
        .upsert({'usuario_id': userId, 'permiso_id': permissionId});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> removePermission(String userId, int permissionId) async {
    try {
      await _client
        .from('usuario_permiso')
        .delete()
        .eq('usuario_id', userId)
        .eq('permiso_id', permissionId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> changeUserProfileType(String userId, String profileType) async {
    try {
      await _client
        .from('usuarios')
        .update({'tipo_perfil': profileType})
        .eq('id', userId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateUserProfile(String userId, {String? name, String? username}) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['nombre'] = name;
      if (username != null) updates['username'] = username;

      if (updates.isNotEmpty) {
        await _client
          .from('usuarios')
          .update(updates)
          .eq('id', userId);
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
