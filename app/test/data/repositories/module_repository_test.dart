import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/data/repositories/supabase_module_repository.dart';
import '../../helpers/fake_supabase_db.dart';

void main() {
  late SupabaseModuleRepository repository;
  late FakeSupabaseDb fakeDb;

  setUp(() {
    fakeDb = FakeSupabaseDb();
    repository = SupabaseModuleRepository(fakeDb);
  });

  group('ModuleRepository', () {
    final tModuleData = {
      'id': 1,
      'codigo': 'mod1',
      'nombre': 'Module 1',
      'activo': true,
    };
    final tCompanyId = 123;

    test('getModules should return active modules sorted', () async {
      // Arrange
      fakeDb.tables['modulos'] = [
        tModuleData,
        { ...tModuleData, 'id': 2, 'codigo': 'mod2', 'nombre': 'Alpha Module', 'activo': true },
        { ...tModuleData, 'id': 3, 'codigo': 'mod3', 'activo': false }, // inactive
      ];

      // Act
      final result = await repository.getModules();

      // Assert
      expect(result.length, 2);
      expect(result[0]['codigo'], 'mod2'); // Sorted by name Alpha first
      expect(result[1]['codigo'], 'mod1');
    });

    test('getActiveModules (Company Level) returns correct codes', () async {
      // Arrange
      fakeDb.tables['empresa_modulos'] = [
         // Joins are mocked by pre-joined data or simple filtering in our Fake currently.
         // Since our Fake .select('*, modulos(codigo)') logic is basic, 
         // we might need to verify if our repo relies on real Join Query behavior.
         // Repository: .select('*, modulos(codigo)')
         // FakeDb currently doesn't do deep joins automatically.
         // We can simulate join result by putting JOINED structure in the table content for testing, 
         // OR update FakeDb to handle simple joins.
         // Let's assume for this specific test, the data returned by select matches expected structure.
         { 
           'empresa_id': tCompanyId, 
           'activo': true, 
           'modulos': {'codigo': 'mod_company'} 
         }
      ];

      // Act
      final result = await repository.getActiveModules(companyId: tCompanyId);

      // Assert
      expect(result, contains('mod_company'));
    });

    test('toggleCompanyModule inserts or updates', () async {
      // Act: Toggle On (Insert/Upsert)
      await repository.toggleCompanyModule(
        companyId: tCompanyId,
        moduleId: 99,
        isActive: true,
      );

      // Assert
      final rows = fakeDb.tables['empresa_modulos']!;
      expect(rows, hasLength(1));
      expect(rows.first['empresa_id'], tCompanyId);
      expect(rows.first['modulo_id'], 99);
      expect(rows.first['activo'], true);

      // Act: Toggle Off (Update)
      await repository.toggleCompanyModule(
        companyId: tCompanyId,
        moduleId: 99,
        isActive: false,
      );

      // Assert
      expect(rows.first['activo'], false);
    });
  });
}
