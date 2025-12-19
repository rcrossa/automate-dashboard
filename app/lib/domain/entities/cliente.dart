import 'package:equatable/equatable.dart';

class Cliente extends Equatable {
  final int id;
  final int empresaId;
  final int? sucursalId;
  final String nombre;
  final String? apellido;
  final String? email;
  final String? telefono;
  final String? direccion;
  final String? documentoIdentidad;
  final String? razonSocial;
  final String? cuit;
  final String tipoCliente; // 'persona' or 'empresa'
  final String? notas;
  final String estado;
  final DateTime fechaCreacion;
  final DateTime actualizadoEn;

  const Cliente({
    required this.id,
    required this.empresaId,
    this.sucursalId,
    required this.nombre,
    this.apellido,
    this.email,
    this.telefono,
    this.direccion,
    this.documentoIdentidad,
    this.razonSocial,
    this.cuit,
    this.tipoCliente = 'persona',
    this.notas,
    required this.estado,
    required this.fechaCreacion,
    required this.actualizadoEn,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      empresaId: json['empresa_id'] as int,
      sucursalId: json['sucursal_id'] as int?,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String?,
      email: json['email'] as String?,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      documentoIdentidad: json['documento_identidad'] as String?,
      razonSocial: json['razon_social'] as String?,
      cuit: json['cuit'] as String?,
      tipoCliente: json['tipo_cliente'] as String? ?? 'persona',
      notas: json['notas'] as String?,
      estado: json['estado'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String).toLocal(),
      actualizadoEn: DateTime.parse(json['actualizado_en'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empresa_id': empresaId,
      'sucursal_id': sucursalId,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'documento_identidad': documentoIdentidad,
      'razon_social': razonSocial,
      'cuit': cuit,
      'tipo_cliente': tipoCliente,
      'notas': notas,
      'estado': estado,
    };
  }

  Cliente copyWith({
    int? id,
    int? empresaId,
    int? sucursalId,
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? direccion,
    String? documentoIdentidad,
    String? razonSocial,
    String? cuit,
    String? tipoCliente,
    String? notas,
    String? estado,
    DateTime? fechaCreacion,
    DateTime? actualizadoEn,
  }) {
    return Cliente(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      sucursalId: sucursalId ?? this.sucursalId,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      documentoIdentidad: documentoIdentidad ?? this.documentoIdentidad,
      razonSocial: razonSocial ?? this.razonSocial,
      cuit: cuit ?? this.cuit,
      tipoCliente: tipoCliente ?? this.tipoCliente,
      notas: notas ?? this.notas,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  List<Object?> get props => [
    id, empresaId, sucursalId, nombre, apellido, email, telefono, 
    direccion, documentoIdentidad, razonSocial, cuit, tipoCliente, 
    notas, estado, fechaCreacion, actualizadoEn
  ];
}
