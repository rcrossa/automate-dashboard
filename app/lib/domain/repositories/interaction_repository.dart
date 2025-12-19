import '../../domain/entities/interaccion.dart';

abstract class InteractionRepository {
  Future<List<Interaccion>> getInteractions(String userId, {int? empresaId});
  Future<void> logInteraction({
    required String userId,
    int empresaId = 1,  // Single-tenant: default to 1
    String? typeLegacy, // Deprecated
    int? tipoInteraccionId,
    String? description,
    Map<String, dynamic>? datosExtra,
  });
}
