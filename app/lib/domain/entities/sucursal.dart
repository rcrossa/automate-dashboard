import 'package:equatable/equatable.dart';

class Sucursal extends Equatable {
  final int id;
  final int empresaId;
  final String nombre;
  final String? direccion;
  final DateTime fechaCreacion;

  const Sucursal({
    required this.id,
    this.empresaId = 1,  // Single-tenant: siempre empresa ID 1
    required this.nombre,
    this.direccion,
    required this.fechaCreacion,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as int,
      empresaId: json['empresa_id'] as int? ?? 1,  // Single-tenant fallback
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String?,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String).toLocal(),
    );
  }

  Sucursal copyWith({
    int? id,
    int? empresaId,
    String? nombre,
    String? direccion,
    DateTime? fechaCreacion,
  }) {
    return Sucursal(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  List<Object?> get props => [id, empresaId, nombre, direccion, fechaCreacion];
}
