import '../../domain/entities/tipo_reclamo.dart';
import '../../domain/entities/tipo_interaccion.dart';

abstract class CrmConfigRepository {
  // Tipos de Reclamo
  Future<List<TipoReclamo>> getTiposReclamo({int? empresaId});
  Future<TipoReclamo> createTipoReclamo(TipoReclamo tipo);
  Future<void> updateTipoReclamo(TipoReclamo tipo);
  Future<void> deleteTipoReclamo(int id);

  // Tipos de Interacción
  Future<List<TipoInteraccion>> getTiposInteraccion({int? empresaId});
  Future<TipoInteraccion> createTipoInteraccion(TipoInteraccion tipo);
  Future<void> updateTipoInteraccion(TipoInteraccion tipo);
  Future<void> deleteTipoInteraccion(int id);
}
