import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/crm_config_repository.dart';
import '../../domain/entities/tipo_reclamo.dart';
import '../../domain/entities/tipo_interaccion.dart';

class SupabaseCrmConfigRepository implements CrmConfigRepository {
  final SupabaseClient _client;

  SupabaseCrmConfigRepository(this._client);

  // Tipos de Reclamo

  @override
  Future<List<TipoReclamo>> getTiposReclamo({int? empresaId}) async {
    // RLS handles filtering, but we can be explicit if needed.
    // Usually auth.uid() context is enough for RLS.
    final response = await _client
        .from('tipos_reclamo')
        .select()
        .eq('activo', true)
        .order('nombre');
    
    return (response as List).map((e) => TipoReclamo.fromJson(e)).toList();
  }

  @override
  Future<TipoReclamo> createTipoReclamo(TipoReclamo tipo) async {
    final response = await _client.from('tipos_reclamo').insert({
      'empresa_id': tipo.empresaId,
      'nombre': tipo.nombre,
      'descripcion': tipo.descripcion,
      'prioridad_default': tipo.prioridadDefault,
      'campos_requeridos': tipo.camposRequeridos,
      'activo': tipo.activo,
    }).select().single();

    return TipoReclamo.fromJson(response);
  }

  @override
  Future<void> updateTipoReclamo(TipoReclamo tipo) async {
    await _client.from('tipos_reclamo').update({
      'nombre': tipo.nombre,
      'descripcion': tipo.descripcion,
      'prioridad_default': tipo.prioridadDefault,
      'campos_requeridos': tipo.camposRequeridos,
      'activo': tipo.activo,
    }).eq('id', tipo.id);
  }

  @override
  Future<void> deleteTipoReclamo(int id) async {
    // Soft delete usually, but here we just set activo = false usually.
    // Or hard delete if no constraints prevent it. Assuming hard delete for now via method name.
    await _client.from('tipos_reclamo').delete().eq('id', id);
  }

  // Tipos de Interacción

  @override
  Future<List<TipoInteraccion>> getTiposInteraccion({int? empresaId}) async {
    final response = await _client
        .from('tipos_interaccion')
        .select()
        .eq('activo', true)
        .order('nombre');

    return (response as List).map((e) => TipoInteraccion.fromJson(e)).toList();
  }

  @override
  Future<TipoInteraccion> createTipoInteraccion(TipoInteraccion tipo) async {
    final response = await _client.from('tipos_interaccion').insert({
      'empresa_id': tipo.empresaId,
      'nombre': tipo.nombre,
      'icono': tipo.icono,
      'activo': tipo.activo,
    }).select().single();

    return TipoInteraccion.fromJson(response);
  }

  @override
  Future<void> updateTipoInteraccion(TipoInteraccion tipo) async {
    await _client.from('tipos_interaccion').update({
      'nombre': tipo.nombre,
      'icono': tipo.icono,
      'activo': tipo.activo,
    }).eq('id', tipo.id);
  }

  @override
  Future<void> deleteTipoInteraccion(int id) async {
    await _client.from('tipos_interaccion').delete().eq('id', id);
  }
}
