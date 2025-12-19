import 'package:equatable/equatable.dart';
import 'producto_sugerido.dart';
import 'conversation_segment.dart';

/// Representa una transcripción de audio realizada por un ejecutivo
/// con análisis de inteligencia de negocio para identificar oportunidades de productos
class TranscripcionEjecutivo extends Equatable {
  final int id;
  final DateTime fechaCreacion;
  final int empresaId;
  final int? sucursalId;

  // Ejecutivo que realizó la grabación
  final String ejecutivoId;
  final String ejecutivoNombre;
  final String? ejecutivoRol;

  // Cliente relacionado (opcional, pero al menos uno de cliente o reclamo debe existir)
  final int? clienteId;
  final String? clienteNombre;
  final String? clienteTelefono;
  final String? clienteEmail;

  // Reclamo relacionado (opcional)
  final int? reclamoId;

  // Tipo de grabación
  final String tipoGrabacion; // 'nota_voz' | 'conversacion'

  // Transcripción del audio
  final String textoTranscrito;
  final double? confidence; // 0.0 - 1.0 (confianza de Whisper)
  final double? duracionSegundos;
  final String? idiomaDetectado;

  // Diarización (solo para tipo 'conversacion')
  final List<ConversationSegment>? segmentosConversacion;
  final List<Participant>? participantes;
  final int? numSpeakers;

  // Análisis de IA (generado por backend Python)
  final List<ProductoSugerido>? productosSugeridos;
  final List<String>? palabrasClave;
  final String? sentimiento; // 'positivo', 'neutral', 'negativo'
  final String? prioridad; // 'alta', 'media', 'baja'
  final Map<String, dynamic>? analisisCompleto;
  final DateTime? fechaAnalisis;

  // Soft delete
  final bool eliminado;
  final DateTime? fechaEliminado;

  const TranscripcionEjecutivo({
    required this.id,
    required this.fechaCreacion,
    required this.empresaId,
    this.sucursalId,
    required this.ejecutivoId,
    required this.ejecutivoNombre,
    this.ejecutivoRol,
    this.clienteId,
    this.clienteNombre,
    this.clienteTelefono,
    this.clienteEmail,
    this.reclamoId,
    this.tipoGrabacion = 'nota_voz',
    required this.textoTranscrito,
    this.confidence,
    this.duracionSegundos,
    this.idiomaDetectado,
    this.segmentosConversacion,
    this.participantes,
    this.numSpeakers,
    this.productosSugeridos,
    this.palabrasClave,
    this.sentimiento,
    this.prioridad,
    this.analisisCompleto,
    this.fechaAnalisis,
    this.eliminado = false,
    this.fechaEliminado,
  });

  factory TranscripcionEjecutivo.fromJson(Map<String, dynamic> json) {
    return TranscripcionEjecutivo(
      id: json['id'] as int,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      empresaId: json['empresa_id'] as int,
      sucursalId: json['sucursal_id'] as int?,
      ejecutivoId: json['ejecutivo_id'] as String,
      ejecutivoNombre: json['ejecutivo_nombre'] as String,
      ejecutivoRol: json['ejecutivo_rol'] as String?,
      clienteId: json['cliente_id'] as int?,
      clienteNombre: json['cliente_nombre'] as String?,
      clienteTelefono: json['cliente_telefono'] as String?,
      clienteEmail: json['cliente_email'] as String?,
      reclamoId: json['reclamo_id'] as int?,
      tipoGrabacion: json['tipo_grabacion'] as String? ?? 'nota_voz',
      textoTranscrito: json['texto_transcrito'] as String,
      confidence: json['confidence'] != null 
          ? (json['confidence'] as num).toDouble() 
          : null,
      duracionSegundos: json['duracion_segundos'] != null
          ? (json['duracion_segundos'] as num).toDouble()
          : null,
      idiomaDetectado: json['idioma_detectado'] as String?,
      segmentosConversacion: json['segmentos_conversacion'] != null
          ? (json['segmentos_conversacion'] as List)
              .map((s) => ConversationSegment.fromJson(s as Map<String, dynamic>))
              .toList()
          : null,
      participantes: json['participantes'] != null
          ? (json['participantes'] as List)
              .map((p) => Participant.fromJson(p as Map<String, dynamic>))
              .toList()
          : null,
      numSpeakers: json['num_speakers'] as int?,
      productosSugeridos: json['productos_sugeridos'] != null
          ? (json['productos_sugeridos'] as List)
              .map((p) => ProductoSugerido.fromJson(p as Map<String, dynamic>))
              .toList()
          : null,
      palabrasClave: json['palabras_clave'] != null
          ? List<String>.from(json['palabras_clave'] as List)
          : null,
      sentimiento: json['sentimiento'] as String?,
      prioridad: json['prioridad'] as String?,
      analisisCompleto: json['analisis_completo'] as Map<String, dynamic>?,
      fechaAnalisis: json['fecha_analisis'] != null
          ? DateTime.parse(json['fecha_analisis'] as String)
          : null,
      eliminado: json['eliminado'] as bool? ?? false,
      fechaEliminado: json['fecha_eliminado'] != null
          ? DateTime.parse(json['fecha_eliminado'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'empresa_id': empresaId,
      'sucursal_id': sucursalId,
      'ejecutivo_id': ejecutivoId,
      'ejecutivo_nombre': ejecutivoNombre,
      'ejecutivo_rol': ejecutivoRol,
      'cliente_id': clienteId,
      'cliente_nombre': clienteNombre,
      'cliente_telefono': clienteTelefono,
      'cliente_email': clienteEmail,
      'reclamo_id': reclamoId,
      'tipo_grabacion': tipoGrabacion,
      'texto_transcrito': textoTranscrito,
      'confidence': confidence,
      'duracion_segundos': duracionSegundos,
      'idioma_detectado': idiomaDetectado,
      'segmentos_conversacion': segmentosConversacion?.map((s) => s.toJson()).toList(),
      'participantes': participantes?.map((p) => p.toJson()).toList(),
      'num_speakers': numSpeakers,
      'productos_sugeridos': productosSugeridos?.map((p) => p.toJson()).toList(),
      'palabras_clave': palabrasClave,
      'sentimiento': sentimiento,
      'prioridad': prioridad,
      'analisis_completo': analisisCompleto,
      'fecha_analisis': fechaAnalisis?.toIso8601String(),
      'eliminado': eliminado,
      'fecha_eliminado': fechaEliminado?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        fechaCreacion,
        empresaId,
        sucursalId,
        ejecutivoId,
        ejecutivoNombre,
        ejecutivoRol,
        clienteId,
        clienteNombre,
        clienteTelefono,
        clienteEmail,
        reclamoId,
        textoTranscrito,
        confidence,
        duracionSegundos,
        idiomaDetectado,
        productosSugeridos,
        palabrasClave,
        sentimiento,
        prioridad,
        analisisCompleto,
        fechaAnalisis,
        eliminado,
        fechaEliminado,
      ];
}
