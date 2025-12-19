import '../../domain/entities/reclamo.dart';
import '../../domain/entities/historial_reclamo.dart';

abstract class ReclamoRepository {
  Future<List<Reclamo>> getClaims(
    String userId, {
    int? empresaId, 
    String? query, 
    int? clientId,
    int limit = 20, 
    int offset = 0,
    int? sucursalId,
    String? estadoFilter,
  });
  
  Future<void> deleteClaim(int id);
  
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
  });

  Future<void> updateStatus(int claimId, String newStatus);
  
  Future<void> updateClaim(Reclamo reclamo, {required String userId, required String reason});
  
  Future<List<HistorialReclamo>> getClaimHistory(int reclamoId);
}
