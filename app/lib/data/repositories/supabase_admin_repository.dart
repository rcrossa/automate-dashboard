import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/admin_repository.dart';

class SupabaseAdminRepository implements AdminRepository {
  final SupabaseClient _client;

  SupabaseAdminRepository(this._client);

  @override
  Future<void> createCompany({
    required String name,
    required String code,
    required String address,
    String? logoUrl,
    String? themeColor,
  }) async {
    try {
      // 1. Crear Empresa
      final empresaResp = await _client
          .from('empresas')
          .insert({
            'nombre': name,
            'codigo': code,
            'logo_url': logoUrl,
            'color_tema': themeColor,
          })
          .select()
          .single();

      final empresaId = empresaResp['id'];

      // 2. Crear Sucursal Matriz
      await _client.from('sucursales').insert({
        'empresa_id': empresaId,
        'nombre': 'Casa Matriz',
        'direccion': address,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> inviteUser({
    required String email,
    required int companyId,
    required int? branchId,
    required String roleName,
  }) async {
    try {
      // Obtener ID del rol
      final rolResp = await _client
          .from('roles')
          .select('id')
          .eq('nombre', roleName)
          .single();
      
      final rolId = rolResp['id'];

      // 1. Verificar si el usuario ya existe en la tabla 'usuarios'
      final userResp = await _client
          .from('usuarios')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (userResp != null) {
        // CASO A: El usuario YA EXISTE (ej: se registró manual). Lo actualizamos directo.
        await _client.from('usuarios').update({
          'empresa_id': companyId,
          'sucursal_id': branchId,
          'rol_id': rolId,
          // Si es admin, actualizamos su perfil también
          'tipo_perfil': roleName == 'admin' ? 'admin' : 'usuario', 
        }).eq('id', userResp['id']);
      } else {
        // CASO B: El usuario NO EXISTE. Creamos la invitación.
        await _client.from('invitaciones').insert({
          'email': email.trim(),
          'empresa_id': companyId,
          'sucursal_id': branchId,
          'rol_id': rolId,
          'creado_por': _client.auth.currentUser?.id,
        });
      }
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      return await _client
          .from('empresas')
          .select('*, sucursales(*)')
          .order('nombre');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingInvitations() async {
    try {
      return await _client
          .from('invitaciones')
          .select('*, empresas(nombre), roles(nombre)')
          .order('fecha_creacion', ascending: false);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteInvitation(String id) async {
    try {
      await _client.from('invitaciones').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
