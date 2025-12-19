import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/domain/repositories/transcripcion_repository.dart';
import 'package:msasb_app/domain/entities/transcripcion_ejecutivo.dart';

class SupabaseTranscripcionRepository implements TranscripcionRepository {
  final SupabaseClient _supabase;

  SupabaseTranscripcionRepository(this._supabase);

  @override
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
  }) async {
    final data = {
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
      'idioma_detectado': idiomaDetectado ?? 'es',
      'segmentos_conversacion': segmentosConversacion,
      'participantes': participantes,
      'num_speakers': numSpeakers,
    };

    final response = await _supabase
        .from('transcripciones_ejecutivo')
        .insert(data)
        .select()
        .single();

    return TranscripcionEjecutivo.fromJson(response);
  }

  @override
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByCliente(
      int clienteId) async {
    final response = await _supabase
        .from('transcripciones_ejecutivo')
        .select()
        .eq('cliente_id', clienteId)
        .eq('eliminado', false)
        .order('fecha_creacion', ascending: false);

    return (response as List)
        .map((json) => TranscripcionEjecutivo.fromJson(json))
        .toList();
  }

  @override
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByReclamo(
      int reclamoId) async {
    final response = await _supabase
        .from('transcripciones_ejecutivo')
        .select()
        .eq('reclamo_id', reclamoId)
        .eq('eliminado', false)
        .order('fecha_creacion', ascending: false);

    return (response as List)
        .map((json) => TranscripcionEjecutivo.fromJson(json))
        .toList();
  }

  @override
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByEjecutivo(
    String ejecutivoId, {
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    var query = _supabase
        .from('transcripciones_ejecutivo')
        .select()
        .eq('ejecutivo_id', ejecutivoId)
        .eq('eliminado', false);

    if (fechaDesde != null) {
      query = query.gte('fecha_creacion', fechaDesde.toIso8601String());
    }

    if (fechaHasta != null) {
      query = query.lte('fecha_creacion', fechaHasta.toIso8601String());
    }

    final response = await query.order('fecha_creacion', ascending: false);

    return (response as List)
        .map((json) => TranscripcionEjecutivo.fromJson(json))
        .toList();
  }

  @override
  Future<List<TranscripcionEjecutivo>> getTranscripcionesByEmpresa(
    int empresaId, {
    int? limit,
    int? offset,
  }) async {
    var query = _supabase
        .from('transcripciones_ejecutivo')
        .select()
        .eq('empresa_id', empresaId)
        .eq('eliminado', false)
        .order('fecha_creacion', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (offset != null) {
      query = query.range(offset, offset + (limit ?? 20) - 1);
    }

    final response = await query;

    return (response as List)
        .map((json) => TranscripcionEjecutivo.fromJson(json))
        .toList();
  }

  @override
  Future<List<TranscripcionEjecutivo>> searchTranscripciones({
    required int empresaId,
    required String query,
    int limit = 50,
  }) async {
    // Usando la función PostgreSQL creada en la migración
    final response = await _supabase.rpc(
      'buscar_transcripciones',
      params: {
        'p_empresa_id': empresaId,
        'p_query': query,
        'p_limit': limit,
      },
    );

    return (response as List)
        .map((json) => TranscripcionEjecutivo.fromJson(json))
        .toList();
  }

  @override
  Future<TranscripcionEjecutivo?> getTranscripcionById(int id) async {
    final response = await _supabase
        .from('transcripciones_ejecutivo')
        .select()
        .eq('id', id)
        .eq('eliminado', false)
        .maybeSingle();

    if (response == null) return null;

    return TranscripcionEjecutivo.fromJson(response);
  }

  @override
  Future<void> updateTranscripcion(TranscripcionEjecutivo transcripcion) async {
    await _supabase
        .from('transcripciones_ejecutivo')
        .update(transcripcion.toJson())
        .eq('id', transcripcion.id);
  }

  @override
  Future<void> deleteTranscripcion(int id) async {
    // Soft delete
    await _supabase.from('transcripciones_ejecutivo').update({
      'eliminado': true,
      'fecha_eliminado': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }
}
