import 'package:equatable/equatable.dart';

class TipoReclamo extends Equatable {
  final int id;
  final int empresaId;
  final String nombre;
  final String? descripcion;
  final String prioridadDefault;
  final List<dynamic> camposRequeridos; // JSON list of field definitions
  final bool activo;
  final DateTime? createdAt;

  const TipoReclamo({
    required this.id,
    required this.empresaId,
    required this.nombre,
    this.descripcion,
    this.prioridadDefault = 'media',
    this.camposRequeridos = const [],
    this.activo = true,
    this.createdAt,
  });

  factory TipoReclamo.fromJson(Map<String, dynamic> json) {
    return TipoReclamo(
      id: json['id'],
      empresaId: json['empresa_id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      prioridadDefault: json['prioridad_default'] ?? 'media',
      camposRequeridos: json['campos_requeridos'] ?? [],
      activo: json['activo'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'prioridad_default': prioridadDefault,
      'campos_requeridos': camposRequeridos,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TipoReclamo copyWith({
    int? id,
    int? empresaId,
    String? nombre,
    String? descripcion,
    String? prioridadDefault,
    List<dynamic>? camposRequeridos,
    bool? activo,
    DateTime? createdAt,
  }) {
    return TipoReclamo(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      prioridadDefault: prioridadDefault ?? this.prioridadDefault,
      camposRequeridos: camposRequeridos ?? this.camposRequeridos,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, empresaId, nombre, descripcion, prioridadDefault, 
    camposRequeridos, activo, createdAt
  ];
}
