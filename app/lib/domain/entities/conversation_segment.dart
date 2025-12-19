import 'package:equatable/equatable.dart';

/// Representa un segmento de conversación con speaker identificado
class ConversationSegment extends Equatable {
  final String speaker; // 'SPEAKER_00', 'SPEAKER_01', etc.
  final String? role; // 'ejecutivo', 'cliente', null
  final double start; // Tiempo de inicio en segundos
  final double end; // Tiempo de fin en segundos
  final String text; // Texto transcrito del segmento
  final double? confidence; // Confianza de la transcripción

  const ConversationSegment({
    required this.speaker,
    this.role,
    required this.start,
    required this.end,
    required this.text,
    this.confidence,
  });

  factory ConversationSegment.fromJson(Map<String, dynamic> json) {
    return ConversationSegment(
      speaker: json['speaker'] as String,
      role: json['role'] as String?,
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      text: json['text'] as String,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'role': role,
      'start': start,
      'end': end,
      'text': text,
      'confidence': confidence,
    };
  }

  @override
  List<Object?> get props => [speaker, role, start, end, text, confidence];
}

/// Representa un participante en la conversación
class Participant extends Equatable {
  final String speakerId; // 'SPEAKER_00', 'SPEAKER_01', etc.
  final String role; // 'ejecutivo', 'cliente'
  final String? nombre;
  final String? voiceEmbedding; // Para future speaker recognition

  const Participant({
    required this.speakerId,
    required this.role,
    this.nombre,
    this.voiceEmbedding,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      speakerId: json['speaker_id'] as String,
      role: json['role'] as String,
      nombre: json['nombre'] as String?,
      voiceEmbedding: json['voice_embedding'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker_id': speakerId,
      'role': role,
      'nombre': nombre,
      'voice_embedding': voiceEmbedding,
    };
  }

  @override
  List<Object?> get props => [speakerId, role, nombre, voiceEmbedding];
}
