import '../entities/transcripcion_ejecutivo.dart';

/// Repository para gestionar transcripciones de ejecutivos
abstract class TranscripcionRepository {
  /// Crea una nueva transcripción
  Future<TranscripcionEjecutivo> createTranscripcion({
    required int empresaId,
    int? sucursalId,
    required String ejecutivoId,
    required String ejecutivoNombre,
    String? ejecutivoRol,
    int? clienteId,
    String? clienteNombre,
    String? clienteTelefono,
    String? clienteEmail,
    int? reclamoId,
    String tipoGrabacion = 'nota_voz',
    required String textoTranscrito,
    double? confidence,
    double? duracionSegundos,
    String? idiomaDetectado,
    List<Map<String, dynamic>>? segmentosConversacion,
    List<Map<String, dynamic>>? participantes,
    int? numSpeakers,
  });

  /// Obtiene transcripciones por cliente
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByCliente(int clienteId);

  /// Obtiene transcripciones por reclamo
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByReclamo(int reclamoId);

  /// Obtiene transcripciones por ejecutivo
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByEjecutivo(
    String ejecutivoId, {
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  });

  /// Obtiene transcripciones por empresa
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByEmpresa(
    int empresaId, {
    int? limit,
    int? offset,
  });

  /// Busca transcripciones por texto (full-text search)
  Future<List<TranscripcionEjecutivo>> searchTranscripciones({
    required int empresaId,
    required String query,
    int limit = 50,
  });

  /// Obtiene una transcripción por ID
  Future<TranscripcionEjecutivo?> getTranscripcionById(int id);

  /// Actualiza una transcripción (principalmente para análisis de IA)
  Future<void> updateTranscripcion(TranscripcionEjecutivo transcripcion);

  /// Soft delete de una transcripción
  Future<void> deleteTranscripcion(int id);
}
