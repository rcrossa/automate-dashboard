import 'package:equatable/equatable.dart';

/// Representa un producto sugerido por el análisis de IA
class ProductoSugerido extends Equatable {
  final String nombre;
  final String categoria;
  final double score; // 0.0 - 1.0
  final String razon;

  const ProductoSugerido({
    required this.nombre,
    required this.categoria,
    required this.score,
    required this.razon,
  });

  factory ProductoSugerido.fromJson(Map<String, dynamic> json) {
    return ProductoSugerido(
      nombre: json['nombre'] as String,
      categoria: json['categoria'] as String,
      score: (json['score'] as num).toDouble(),
      razon: json['razon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'score': score,
      'razon': razon,
    };
  }

  @override
  List<Object?> get props => [nombre, categoria, score, razon];
}
