import 'package:equatable/equatable.dart';

class HistorialReclamo extends Equatable {
  final int id;
  final int reclamoId;
  final String usuarioId;
  final String tipoAccion; // 'creacion', 'edicion', 'cambio_estado'
  final String? descripcion;
  final Map<String, dynamic> datosCambio;
  final DateTime fecha;

  const HistorialReclamo({
    required this.id,
    required this.reclamoId,
    required this.usuarioId,
    required this.tipoAccion,
    this.descripcion,
    this.datosCambio = const {},
    required this.fecha,
  });

  factory HistorialReclamo.fromJson(Map<String, dynamic> json) {
    return HistorialReclamo(
      id: json['id'],
      reclamoId: json['reclamo_id'],
      usuarioId: json['usuario_id'],
      tipoAccion: json['tipo_accion'],
      descripcion: json['descripcion'],
      datosCambio: json['datos_cambio'] != null ? Map<String, dynamic>.from(json['datos_cambio']) : {},
      fecha: DateTime.parse(json['fecha']).toLocal(),
    );
  }

  @override
  List<Object?> get props => [
    id, reclamoId, usuarioId, tipoAccion, descripcion, 
    datosCambio, fecha
  ];
}
