import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioConPermisos extends Equatable {
  final String id;
  final String email;
  final String nombre;
  final String? username;
  final String rol;
  final String? tipoPerfil;  // tipo_perfil from DB (super_admin, admin, etc)
  final int? empresaId;
  final int? sucursalId;
  final List<String> capacidades;

  const UsuarioConPermisos({
    required this.id,
    required this.email,
    required this.nombre,
    this.username,
    required this.rol,
    this.tipoPerfil,
    this.empresaId,
    this.sucursalId,
    required this.capacidades,
  });

  factory UsuarioConPermisos.fromJson(Map<String, dynamic> json) {
    final rolNombre = json['roles']?['nombre'] as String?;
    final rol = rolNombre ?? json['tipo_perfil'] ?? '';
    final tipoPerfil = json['tipo_perfil'] as String?;
    
    // Single-tenant: empresa_id siempre es 1
    // La base de datos ya lo asigna automáticamente en el trigger
    final empresaId = json['empresa_id'] as int? ?? 1;
    
    return UsuarioConPermisos(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      username: json['username'],
      rol: rol,
      tipoPerfil: tipoPerfil,
      empresaId: empresaId,
      sucursalId: json['sucursal_id'],
      capacidades: [],
    );
  }

  UsuarioConPermisos copyWith({
    String? id,
    String? email,
    String? nombre,
    String? username,
    String? rol,
    String? tipoPerfil,
    int? empresaId,
    int? sucursalId,
    List<String>? capacidades,
  }) {
    return UsuarioConPermisos(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      username: username ?? this.username,
      rol: rol ?? this.rol,
      tipoPerfil: tipoPerfil ?? this.tipoPerfil,
      empresaId: empresaId ?? this.empresaId,
      sucursalId: sucursalId ?? this.sucursalId,
      capacidades: capacidades ?? this.capacidades,
    );
  }

  @override
  List<Object?> get props => [
    id, email, nombre, username, rol, tipoPerfil, empresaId, sucursalId, capacidades
  ];
}

Future<UsuarioConPermisos?> obtenerUsuarioConPermisos() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;
  try {
    // Obtener datos del usuario incluyendo el nombre del rol
    final response = await Supabase.instance.client
        .from('usuarios')
        .select('id, email, nombre, username, tipo_perfil, empresa_id, sucursal_id, roles(nombre)')
        .eq('id', user.id)
        .single();

    // Priorizar el nombre del rol desde la tabla roles, si no existe usar tipo_perfil (ej: super_admin legacy)
    final rolNombre = response['roles']?['nombre'] as String?;
    final rol = rolNombre ?? response['tipo_perfil'] ?? '';
    
    // Obtener permisos desde la tabla usuario_permiso con join a permisos
    final permisosResp = await Supabase.instance.client
        .from('usuario_permiso')
        .select('permisos(nombre)')
        .eq('usuario_id', user.id);
    
    final capacidades = <String>[];
    for (var p in (permisosResp as List)) {
      if (p['permisos'] != null && p['permisos']['nombre'] != null) {
        capacidades.add(p['permisos']['nombre']);
      }
    }
    
    return UsuarioConPermisos(
      id: response['id'] ?? user.id, // Fallback to auth id if not in response
      email: response['email'] ?? '',
      nombre: response['nombre'] ?? '',
      username: response['username'],
      rol: rol,
      empresaId: response['empresa_id'],
      sucursalId: response['sucursal_id'],
      capacidades: capacidades,
    );
  } catch (e) {
    // Si la consulta falla (por ejemplo, no hay usuario), retorna null
    return null;
  }
}
