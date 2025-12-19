import 'dart:async';
import 'package:msasb_app/domain/repositories/auth_repository.dart';
import 'package:msasb_app/domain/entities/usuario_con_permisos.dart';
import 'package:msasb_app/domain/entities/empresa.dart';
import 'package:msasb_app/domain/entities/user_session.dart';
import 'package:msasb_app/presentation/providers/module_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

// -- Mock Auth Repository --
class MockAuthRepository implements AuthRepository {
  final bool shouldThrow;
  final String role;
  
  MockAuthRepository({this.shouldThrow = false, this.role = 'admin'});

  @override
  Stream<dynamic> get authStateChanges => const Stream.empty();

  @override
  Future<UsuarioConPermisos?> getCurrentUser() async {
    return UsuarioConPermisos(
      id: 'test-user-id',
      email: 'test@example.com',
      nombre: 'Test User',
      rol: role,
      empresaId: 1,
      capacidades: [],
    );
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (shouldThrow) throw Exception('Simulated Auth Failed');
    return;
  }

  @override
  Future<void> signUp({required String email, required String password, required String nombre, required String username}) async {
    if (shouldThrow) throw Exception('Simulated Register Failed');
    return;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPasswordForEmail(String email) async {}
}

// -- Fake Providers for UserState and Modules --

class FakeUserState extends UserState {
  final UserSession _initialSession;
  FakeUserState([UserSession? session]) : 
    _initialSession = session ?? UserSession(
      usuario: const UsuarioConPermisos(
        id: '1', email: 'test', nombre: 'Test', rol: 'admin', capacidades: [], empresaId: 1
      ),
      empresa: Empresa(
         id: 1, nombre: 'Test Company', codigo: 'TEST', fechaCreacion: DateTime.now()
      )
    );

  @override
  FutureOr<UserSession> build() {
    return _initialSession;
  }
}

class FakeActiveModules extends ActiveModules {
  final List<String> _modules;
  FakeActiveModules(this._modules);

  @override
  FutureOr<List<String>> build() {
    return _modules;
  }
}
