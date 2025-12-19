import 'package:equatable/equatable.dart';

class Reclamo extends Equatable {
  final int id;
  final String usuarioId;
  final int empresaId;
  final int? sucursalId;
  final String? sucursalNombre; // Added for display
  final int? clienteId;
  final String? clienteNombre; // Added for display
  final String titulo;
  final String? descripcion;
  final String estado; // 'pendiente', 'en_proceso', 'resuelto', 'cerrado'
  final String prioridad; // 'baja', 'media', 'alta'
  final int? tipoReclamoId;
  final Map<String, dynamic> datosExtra;
  final String urgencia;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  const Reclamo({
    required this.id,
    required this.usuarioId,
    this.empresaId = 1,  // Single-tenant: siempre empresa ID 1
    this.sucursalId,
    this.sucursalNombre,
    this.clienteId,
    this.clienteNombre,
    required this.titulo,
    this.descripcion,
    this.estado = 'pendiente',
    this.prioridad = 'media',
    this.tipoReclamoId,
    this.datosExtra = const {},
    this.urgencia = 'media',
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory Reclamo.fromJson(Map<String, dynamic> json) {
    String? clientName;
    if (json['clientes'] != null) {
      final c = json['clientes'];
      if (c['razon_social'] != null && c['razon_social'].toString().isNotEmpty) {
        clientName = c['razon_social'];
      } else {
        clientName = '${c['nombre'] ?? ''} ${c['apellido'] ?? ''}'.trim();
      }
    }

    return Reclamo(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as String,
      empresaId: json['empresa_id'] as int? ?? 1,  // Single-tenant fallback
      sucursalId: json['sucursal_id'] as int?,
      sucursalNombre: json['sucursales'] != null ? json['sucursales']['nombre'] as String? : null,
      clienteId: json['cliente_id'] as int?,
      clienteNombre: clientName,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      estado: json['estado'] as String,
      prioridad: json['prioridad'] as String,
      tipoReclamoId: json['tipo_reclamo_id'] as int?,
      datosExtra: json['datos_extra'] != null ? Map<String, dynamic>.from(json['datos_extra']) : {},
      urgencia: json['urgencia'] ?? 'media',
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String).toLocal(),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'empresa_id': empresaId,
      'sucursal_id': sucursalId,
      'cliente_id': clienteId,
      'titulo': titulo,
      'descripcion': descripcion,
      'estado': estado,
      'prioridad': prioridad,
      'tipo_reclamo_id': tipoReclamoId,
      'datos_extra': datosExtra,
      'urgencia': urgencia,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
    };
  }

  Reclamo copyWith({
    int? id,
    String? usuarioId,
    int? empresaId,
    int? sucursalId,
    String? sucursalNombre,
    int? clienteId,
    String? clienteNombre,
    String? titulo,
    String? descripcion,
    String? estado,
    String? prioridad,
    int? tipoReclamoId,
    Map<String, dynamic>? datosExtra,
    String? urgencia,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Reclamo(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      empresaId: empresaId ?? this.empresaId,
      sucursalId: sucursalId ?? this.sucursalId,
      sucursalNombre: sucursalNombre ?? this.sucursalNombre,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      prioridad: prioridad ?? this.prioridad,
      tipoReclamoId: tipoReclamoId ?? this.tipoReclamoId,
      datosExtra: datosExtra ?? this.datosExtra,
      urgencia: urgencia ?? this.urgencia,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  List<Object?> get props => [
    id, usuarioId, empresaId, sucursalId, sucursalNombre, clienteId, 
    clienteNombre, titulo, descripcion, estado, prioridad, tipoReclamoId, 
    datosExtra, urgencia, fechaCreacion, fechaActualizacion
  ];
}
