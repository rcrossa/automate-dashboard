import '../../domain/entities/usuario_con_permisos.dart';

abstract class AuthRepository {
  Future<UsuarioConPermisos?> getCurrentUser();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUp({required String email, required String password, required String nombre, required String username});
  Future<void> resetPasswordForEmail(String email);
  Future<void> signOut();
  Stream<dynamic> get authStateChanges; // Stream de cambios de estado (Supabase AuthState)
}
