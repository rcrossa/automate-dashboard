import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/data/repositories/supabase_reclamo_repository.dart';
import '../../helpers/fake_supabase_db.dart';

void main() {
  late SupabaseReclamoRepository repository;
  late FakeSupabaseDb fakeDb;

  setUp(() {
    fakeDb = FakeSupabaseDb();
    repository = SupabaseReclamoRepository(fakeDb);
  });

  group('ReclamoRepository', () {
    const tUserId = 'user-123';
    final tReclamoData = {
      'id': 1,
      'usuario_id': tUserId,
      'titulo': 'Test Claim',
      'descripcion': 'Description',
      'prioridad': 'alta',
      'estado': 'pendiente',
      'empresa_id': 1,
      'sucursal_id': null,
      'cliente_id': null,
      'tipo_reclamo_id': null,
      'urgencia': 'media',
      'fecha_creacion': DateTime.now().toIso8601String(),
      'fecha_actualizacion': DateTime.now().toIso8601String(),
      'datos_extra': <String, dynamic>{}, // explicit empty map
      // Joins - mocked as embedded data for now or needs join logic in FakeDb
      'sucursales': null,
      'clientes': null,
    };

    test('getClaims should return list of Reclamo', () async {
      // Arrange
      fakeDb.tables['reclamos'] = [tReclamoData];

      // Act
      final result = await repository.getClaims(tUserId, empresaId: 1);

      // Assert
      expect(result.length, 1);
      expect(result.first.titulo, 'Test Claim');
      
      // Verify filtering logic
      await repository.getClaims(tUserId, empresaId: 2); // Should trigger filter, empty
       // Note: To strictly verify filtering, we'd check empty result, but Repo throws if error or returns empty.
      final emptyResult = await repository.getClaims(tUserId, empresaId: 999);
      expect(emptyResult, isEmpty);
    });

    test('createClaim should insert new claim', () async {
      // Act
      await repository.createClaim(
         userId: tUserId,
        empresaId: 1,
        title: 'New Claim',
        priority: 'media',
      );

      // Assert
      expect(fakeDb.tables['reclamos']!.length, 1);
      final created = fakeDb.tables['reclamos']!.first;
      expect(created['titulo'], 'New Claim');
      expect(created['usuario_id'], tUserId);
      expect(created['estado'], 'pendiente');
    });

    test('updateStatus should update claim state', () async {
      // Arrange
      fakeDb.tables['reclamos'] = [tReclamoData];

      // Act
      await repository.updateStatus(1, 'resuelto');

      // Assert
      final updated = fakeDb.tables['reclamos']!.first;
      expect(updated['estado'], 'resuelto');
    });
  });
}
