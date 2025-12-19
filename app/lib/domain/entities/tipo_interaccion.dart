import 'package:equatable/equatable.dart';

class TipoInteraccion extends Equatable {
  final int id;
  final int empresaId;
  final String nombre;
  final String? icono;
  final bool activo;
  final DateTime? createdAt;

  const TipoInteraccion({
    required this.id,
    required this.empresaId,
    required this.nombre,
    this.icono,
    this.activo = true,
    this.createdAt,
  });

  factory TipoInteraccion.fromJson(Map<String, dynamic> json) {
    return TipoInteraccion(
      id: json['id'],
      empresaId: json['empresa_id'],
      nombre: json['nombre'],
      icono: json['icono'],
      activo: json['activo'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'nombre': nombre,
      'icono': icono,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TipoInteraccion copyWith({
    int? id,
    int? empresaId,
    String? nombre,
    String? icono,
    bool? activo,
    DateTime? createdAt,
  }) {
    return TipoInteraccion(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, empresaId, nombre, icono, activo, createdAt];
}
