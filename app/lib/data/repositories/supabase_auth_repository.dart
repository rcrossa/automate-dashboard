import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/usuario_con_permisos.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  Future<UsuarioConPermisos?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final userData = await _fetchUserData(user.id);
      if (userData == null) return null;
      
      // Extract capacidades from the roles structure in userData
      final capacidades = _extractCapacidadesFromUserData(userData);
      return _buildUserWithPermissions(userData, capacidades);
    } catch (e) {
      debugPrint('Error getCurrentUser: $e');
      return null;
    }
  }

  /// Fetches user data from the database including role information
  Future<Map<String, dynamic>?> _fetchUserData(String userId) async {
    final query = await _client
        .from('usuarios')
        .select('''
          *,
          roles(
            id, nombre,
            rol_capacidad(
              capacidades(nombre)
            )
          )
        ''')
        .eq('id', userId)
        .maybeSingle();

    if (query == null) {
      return null;
    }
    return query;
  }

  /// Extracts capacidades from the rol_capacidad structure loaded in userData
  List<String> _extractCapacidadesFromUserData(Map<String, dynamic> userData) {
    try {
      final roles = userData['roles'];
      if (roles == null) return [];

      final rolCapacidad = roles['rol_capacidad'];
      if (rolCapacidad == null || rolCapacidad is! List) return [];

      final capacidades = <String>[];
      for (final rc in rolCapacidad) {
        final capacidadObj = rc['capacidades'];
        if (capacidadObj != null && capacidadObj['nombre'] != null) {
          capacidades.add(capacidadObj['nombre'] as String);
        }
      }

      return capacidades;
    } catch (e) {
      debugPrint('Error extracting capacidades: $e');
      return [];
    }
  }

  /// Builds a UsuarioConPermisos object from raw database data
  UsuarioConPermisos _buildUserWithPermissions(
    Map<String, dynamic> userData,
    List<String> capacidades,
  ) {
    final usuario = UsuarioConPermisos.fromJson(userData);
    return UsuarioConPermisos(
      id: usuario.id,
      email: usuario.email,
      nombre: usuario.nombre,
      username: usuario.username,
      rol: usuario.rol,
      tipoPerfil: usuario.tipoPerfil,  // Pass through tipoPerfil from fromJson
      empresaId: usuario.empresaId,
      sucursalId: usuario.sucursalId,
      capacidades: capacidades,  // Override with extracted capacidades
    );
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      // 1. Obtener email real si es username (Lógica existente)
      String emailFinal = email;
      if (!email.contains('@')) {
        final rpcResp = await _client.rpc('get_email_by_username', params: {'username_input': email});
        if (rpcResp == null) {
          throw const AuthFailure('Usuario no encontrado');
        }
        emailFinal = rpcResp as String;
      }

      // 2. Login
      await _client.auth.signInWithPassword(email: emailFinal, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signUp({required String email, required String password, required String nombre, required String username}) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': nombre,
          'username': username,
        },
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
