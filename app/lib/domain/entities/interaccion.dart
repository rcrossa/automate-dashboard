import 'package:equatable/equatable.dart';

class Interaccion extends Equatable {
  final int id;
  final String usuarioId;
  final int empresaId;
  final String? tipoLegacy; 
  final int? tipoInteraccionId;
  final String? descripcion;
  final Map<String, dynamic> datosExtra;
  final DateTime fecha;

  const Interaccion({
    required this.id,
    required this.usuarioId,
    this.empresaId = 1,  // Single-tenant: siempre empresa ID 1
    this.tipoLegacy,
    this.tipoInteraccionId,
    this.descripcion,
    this.datosExtra = const {},
    required this.fecha,
  });

  factory Interaccion.fromJson(Map<String, dynamic> json) {
    return Interaccion(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as String,
      empresaId: json['empresa_id'] as int? ?? 1,  // Single-tenant fallback
      tipoLegacy: json['tipo'] as String?,
      tipoInteraccionId: json['tipo_interaccion_id'] as int?,
      descripcion: json['descripcion'] as String?,
      datosExtra: json['datos_extra'] != null ? Map<String, dynamic>.from(json['datos_extra']) : {},
      fecha: DateTime.parse(json['fecha'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'empresa_id': empresaId,
      'tipo': tipoLegacy,
      'tipo_interaccion_id': tipoInteraccionId,
      'descripcion': descripcion,
      'datos_extra': datosExtra,
      'fecha': fecha.toIso8601String(),
    };
  }

  Interaccion copyWith({
    int? id,
    String? usuarioId,
    int? empresaId,
    String? tipoLegacy,
    int? tipoInteraccionId,
    String? descripcion,
    Map<String, dynamic>? datosExtra,
    DateTime? fecha,
  }) {
    return Interaccion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      empresaId: empresaId ?? this.empresaId,
      tipoLegacy: tipoLegacy ?? this.tipoLegacy,
      tipoInteraccionId: tipoInteraccionId ?? this.tipoInteraccionId,
      descripcion: descripcion ?? this.descripcion,
      datosExtra: datosExtra ?? this.datosExtra,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  List<Object?> get props => [
    id, usuarioId, empresaId, tipoLegacy, tipoInteraccionId, 
    descripcion, datosExtra, fecha
  ];
}
