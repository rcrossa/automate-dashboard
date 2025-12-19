import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/company_repository.dart';

class SupabaseCompanyRepository implements CompanyRepository {
  final SupabaseClient _client;

  SupabaseCompanyRepository(this._client);

  // === SUCURSALES ===

  @override
  Future<List<Map<String, dynamic>>> getBranches({required int companyId}) async {
    try {
      return await _client
          .from('sucursales')
          .select()
          .eq('empresa_id', companyId)
          .order('nombre');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createBranch({required String name, required String address, required int companyId}) async {
    try {
      await _client.from('sucursales').insert({
        'empresa_id': companyId,
        'nombre': name,
        'direccion': address,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateBranch({required int id, required String name, required String address, required int companyId}) async {
    try {
      await _client.from('sucursales').update({
        'nombre': name,
        'direccion': address,
      }).eq('id', id).eq('empresa_id', companyId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // === PERSONAL ===

  @override
  Future<List<Map<String, dynamic>>> getEmployees({required int companyId}) async {
    try {
      return await _client
          .from('usuarios')
          .select('*, roles(nombre), sucursales(nombre)')
          .eq('empresa_id', companyId)
          .order('nombre');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> inviteEmployee({
    required String email,
    required int? branchId,
    required String roleName,
    required int companyId,
  }) async {
    try {
      // 1. Obtener ID del rol
      final rolResp = await _client
          .from('roles')
          .select('id')
          .eq('nombre', roleName)
          .single();
      final rolId = rolResp['id'];

      // 2. Verificar si usuario ya existe
      final userResp = await _client
          .from('usuarios')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (userResp != null) {
        if (userResp['empresa_id'] != null && userResp['empresa_id'] != companyId) {
          throw const ValidationFailure('El usuario ya pertenece a otra empresa.');
        }

        await _client.from('usuarios').update({
          'empresa_id': companyId,
          'sucursal_id': branchId,
          'rol_id': rolId,
        }).eq('id', userResp['id']);

      } else {
        await _client.from('invitaciones').insert({
          'email': email,
          'empresa_id': companyId,
          'sucursal_id': branchId,
          'rol_id': rolId,
          'creado_por': _client.auth.currentUser?.id,
        });
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateEmployee({
    required String userId,
    required int? branchId,
    required String roleName,
    String? name,
    String? lastName,
    String? username,
    String? phone,
    String? address,
    String? documentId,
    required int companyId,
  }) async {
    try {
      // 1. Obtener ID del rol
      final rolResp = await _client
          .from('roles')
          .select('id')
          .eq('nombre', roleName)
          .single();
      final rolId = rolResp['id'];

      // 2. Actualizar
      await _client.from('usuarios').update({
        'sucursal_id': branchId,
        'rol_id': rolId,
        'nombre': name,
        'apellido': lastName,
        'username': username,
        'telefono': phone,
        'direccion': address,
        'documento_identidad': documentId,
      }).eq('id', userId).eq('empresa_id', companyId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
