import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

part 'session_provider.g.dart';

/// Session data extracted from UserSession for easy access
class SessionData {
  final String userId;
  final String userName;
  final int empresaId;
  final int? sucursalId;
  final String? userRole;

  const SessionData({
    required this.userId,
    required this.userName,
    required this.empresaId,
    this.sucursalId,
    this.userRole,
  });
  
  /// Check if user can delete claims (only supervisor and gerente_sucursal)
  bool get canDeleteClaim {
    if (userRole == null) return false;
    return userRole == 'supervisor' || userRole == 'gerente';
  }
  
  /// Check if user is staff (usuario_regular)
  bool get isStaff {
    return userRole == 'usuario';
  }
  
  /// Check if user is admin or super_admin
  bool get isAdmin {
    if (userRole == null) return false;
    return userRole == 'admin' || userRole == 'super_admin';
  }
}

/// Provider that exposes current session data
@riverpod
SessionData? session(Ref ref) {
  final userSession = ref.watch(userStateProvider);
  
  return userSession.when(
    data: (session) {
      if (session.usuario == null || session.empresa == null) {
        return null;
      }
      
      return SessionData(
        userId: session.usuario!.id,
        userName: session.usuario!.nombre,
        empresaId: session.empresa!.id,
        sucursalId: session.sucursal?.id,
        userRole: session.usuario!.tipoPerfil,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
