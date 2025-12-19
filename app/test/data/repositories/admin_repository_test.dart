import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/data/repositories/supabase_admin_repository.dart';
import '../../helpers/fake_supabase_db.dart';

void main() {
  late SupabaseAdminRepository repository;
  late FakeSupabaseDb fakeDb;

  setUp(() {
    fakeDb = FakeSupabaseDb();
    repository = SupabaseAdminRepository(fakeDb);
  });

  group('AdminRepository', () {
    final tCompanyData = {
      'id': 1, // Supabase IDs are usually ints in our schema or uuids
      'nombre': 'Test Company',
      'codigo': 'CODE',
      'ruc': '12345678901',
      'direccion': 'Address',
      'telefono': '123456789',
      'email_contacto': 'test@company.com',
      'fecha_registro': DateTime.now().toIso8601String(),
    };

    test('getCompanies should return list of companies', () async {
      // Arrange: Seed DB
      fakeDb.tables['empresas'] = [
        tCompanyData,
        { ...tCompanyData, 'id': 2, 'nombre': 'Another Company' }
      ];

      // Act
      final result = await repository.getCompanies();

      // Assert
      expect(result.length, 2);
      expect(result[0]['nombre'], 'Another Company'); // Sorted by name
      expect(result[1]['nombre'], 'Test Company');
    });

    test('createCompany should insert company and Matrix branch', () async {
      // Act
      await repository.createCompany(
        name: 'New Corp',
        code: 'NEW',
        address: 'New Address',
      );

      // Assert
      expect(fakeDb.tables['empresas']!.length, 1);
      final createdCompany = fakeDb.tables['empresas']!.first;
      expect(createdCompany['nombre'], 'New Corp');
      expect(createdCompany['codigo'], 'NEW');

      expect(fakeDb.tables['sucursales']!.length, 1);
      final createdBranch = fakeDb.tables['sucursales']!.first;
      expect(createdBranch['nombre'], 'Casa Matriz');
      expect(createdBranch['direccion'], 'New Address');
      expect(createdBranch['empresa_id'], createdCompany['id']);
    });
  });
}
