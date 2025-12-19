import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/interaction_repository.dart';
import '../../domain/entities/interaccion.dart';

class SupabaseInteractionRepository implements InteractionRepository {
  final SupabaseClient _client;

  SupabaseInteractionRepository(this._client);

  @override
  Future<List<Interaccion>> getInteractions(String userId, {int? empresaId}) async {
    try {
      var query = _client.from('interacciones').select();

      if (empresaId != null) {
        query = query.eq('empresa_id', empresaId);
      } else {
        // Fallback filter
        query = query.eq('usuario_id', userId);
      }

      final resp = await query.order('fecha', ascending: false);
      
      return (resp as List).map((e) => Interaccion.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> logInteraction({
    required String userId,
    required int empresaId,
    String? typeLegacy, // Deprecated
    int? tipoInteraccionId,
    String? description,
    Map<String, dynamic>? datosExtra,
  }) async {
    try {
      final data = {
          'usuario_id': userId,
          'empresa_id': empresaId,
          'tipo': typeLegacy ?? 'INTERACCION_GENERICA', // Fallback for Not Null constraint if exists or legacy consumers
          'tipo_interaccion_id': tipoInteraccionId,
          'descripcion': description,
          'datos_extra': datosExtra ?? {},
      };
      
      await _client.from('interacciones').insert(data);

    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
