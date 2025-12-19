import 'package:equatable/equatable.dart';

class Empresa extends Equatable {
  final int id;
  final String nombre;
  final String codigo;
  final String? logoUrl;
  final String? colorTema;
  final DateTime fechaCreacion;

  const Empresa({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.logoUrl,
    this.colorTema,
    required this.fechaCreacion,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      codigo: json['codigo'] as String,
      logoUrl: json['logo_url'] as String?,
      colorTema: json['color_tema'] as String?,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String).toLocal(),
    );
  }

  Empresa copyWith({
    int? id,
    String? nombre,
    String? codigo,
    String? logoUrl,
    String? colorTema,
    DateTime? fechaCreacion,
  }) {
    return Empresa(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      logoUrl: logoUrl ?? this.logoUrl,
      colorTema: colorTema ?? this.colorTema,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  List<Object?> get props => [id, nombre, codigo, logoUrl, colorTema, fechaCreacion];
}
