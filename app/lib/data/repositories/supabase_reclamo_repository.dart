import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/reclamo_repository.dart';
import '../../domain/entities/reclamo.dart';
import '../../domain/entities/historial_reclamo.dart';

class SupabaseReclamoRepository implements ReclamoRepository {
  final SupabaseClient _client;

  SupabaseReclamoRepository(this._client);

  @override
  Future<List<Reclamo>> getClaims(
    String userId, {
    int? empresaId, 
    String? query,
    int? clientId,
    int limit = 20, 
    int offset = 0,
    int? sucursalId,
    String? estadoFilter,
  }) async {
    try {
      dynamic supabaseQuery;

      if (query != null && query.isNotEmpty) {
        // Use RPC for search - Query built on function result
        supabaseQuery = _client.rpc('buscar_reclamos', params: {'search_query': query});
      } else {
        // Standard table select
        supabaseQuery = _client.from('reclamos').select('*, sucursales(nombre), clientes(nombre, apellido, razon_social)');
      }

      // Apply Filters
      if (empresaId != null) {
        supabaseQuery = supabaseQuery.eq('empresa_id', empresaId);
      } else {
         final userId = _client.auth.currentUser?.id;
         if (userId != null) {
             supabaseQuery = supabaseQuery.eq('usuario_id', userId);
         }
      }
      
      if (empresaId != null) {
        supabaseQuery = supabaseQuery.eq('empresa_id', empresaId);
      } else {
        supabaseQuery = supabaseQuery.eq('usuario_id', userId);
      }
      
      // Filtros Avanzados
      if (sucursalId != null) {
        supabaseQuery = supabaseQuery.eq('sucursal_id', sucursalId);
      }
      if (clientId != null) {
        supabaseQuery = supabaseQuery.eq('cliente_id', clientId);
      }
      if (estadoFilter != null && estadoFilter != 'todos') {
        supabaseQuery = supabaseQuery.eq('estado', estadoFilter);
      }

      // If RPC Search, apply select to get joins (converts to TransformBuilder)
      if (query != null && query.isNotEmpty) {
         supabaseQuery = supabaseQuery.select('*, sucursales(nombre), clientes(nombre, apellido, razon_social)');
      }

      final resp = await supabaseQuery
          .order('fecha_creacion', ascending: false)
          .range(offset, offset + limit - 1);
      
      return (resp as List).map((e) => Reclamo.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createClaim({
    required String userId,
    required int empresaId, 
    int? sucursalId,
    int? clientId,
    required String title,
    String? description,
    required String priority,
    int? tipoReclamoId,
    Map<String, dynamic>? datosExtra,
    String? urgencia,
  }) async {
    try {
      
      await _client.from('reclamos').insert({
        'usuario_id': userId,
        'empresa_id': empresaId,
        'sucursal_id': sucursalId,
        'cliente_id': clientId,
        'titulo': title,
        'descripcion': description,
        'prioridad': priority,
        'estado': 'pendiente',
        'tipo_reclamo_id': tipoReclamoId,
        'datos_extra': datosExtra ?? {}, 

      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateStatus(int claimId, String newStatus) async {
    try {
      await _client
        .from('reclamos')
        .update({'estado': newStatus})
        .eq('id', claimId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateClaim(Reclamo reclamo, {required String userId, required String reason}) async {
    try {
      // 1. Update Claim
      await _client.from('reclamos').update({
        'titulo': reclamo.titulo,
        'descripcion': reclamo.descripcion,
        'estado': reclamo.estado,
        'prioridad': reclamo.prioridad,

        'datos_extra': reclamo.datosExtra,
        'sucursal_id': reclamo.sucursalId,
        'fecha_actualizacion': DateTime.now().toIso8601String(),
      }).eq('id', reclamo.id);

      // 2. Insert History
      await _client.from('historial_reclamos').insert({
        'reclamo_id': reclamo.id,
        'usuario_id': userId,
        'tipo_accion': 'edicion', 
        'descripcion': reason,
        'datos_cambio': reclamo.toJson(),
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HistorialReclamo>> getClaimHistory(int reclamoId) async {
    try {
      final resp = await _client
          .from('historial_reclamos')
          .select()
          .eq('reclamo_id', reclamoId)
          .order('fecha', ascending: false);
      
      return (resp as List).map((e) => HistorialReclamo.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
  @override
  Future<void> deleteClaim(int id) async {
    try {
      await _client.from('reclamos').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

