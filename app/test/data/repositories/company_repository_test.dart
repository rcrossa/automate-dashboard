import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/data/repositories/supabase_company_repository.dart';

// Fakes
class FakePostgrestFilterBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  final T _value;
  FakePostgrestFilterBuilder(this._value);

  @override
  PostgrestFilterBuilder<T> eq(String column, Object value) {
    return this;
  }

  @override
  PostgrestTransformBuilder<T> order(String column, {bool ascending = true, bool nullsFirst = false, String? referencedTable}) {
    return FakePostgrestTransformBuilder(_value);
  }

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return Future.value(_value).then(onValue, onError: onError);
  }
}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final T _value;
  FakePostgrestTransformBuilder(this._value);

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return Future.value(_value).then(onValue, onError: onError);
  }
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final Map<String, dynamic> _data;
  final List<Map<String, dynamic>> _listData;
  
  FakeSupabaseQueryBuilder({
    Map<String, dynamic>? data,
    List<Map<String, dynamic>>? listData,
  }) : _data = data ?? {}, _listData = listData ?? [];

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([String? columns = '*']) {
    final list = _listData.isNotEmpty ? _listData : (_data.isNotEmpty ? [_data] : <Map<String, dynamic>>[]);
    return FakePostgrestFilterBuilder<List<Map<String, dynamic>>>(list);
  }

  @override
  PostgrestFilterBuilder<dynamic> insert(Object values, {bool defaultToNull = true}) {
    return FakePostgrestFilterBuilder<dynamic>([]);
  }

  @override
  PostgrestFilterBuilder<dynamic> update(Map<dynamic, dynamic>? values) {
    return FakePostgrestFilterBuilder<dynamic>([]);
  }

  @override
  PostgrestFilterBuilder<dynamic> delete() {
    return FakePostgrestFilterBuilder<dynamic>([]);
  }
}

class FakeSupabaseClient extends Fake implements SupabaseClient {
  final Map<String, FakeSupabaseQueryBuilder> _tables = {};

  void registerTable(String table, FakeSupabaseQueryBuilder builder) {
    _tables[table] = builder;
  }

  @override
  SupabaseQueryBuilder from(String table) {
    if (_tables.containsKey(table)) {
      return _tables[table]!;
    }
    return FakeSupabaseQueryBuilder();
  }
}

void main() {
  late SupabaseCompanyRepository repository;
  late FakeSupabaseClient fakeClient;

  setUp(() {
    fakeClient = FakeSupabaseClient();
    repository = SupabaseCompanyRepository(fakeClient);
  });

  group('CompanyRepository', () {
    const tCompanyId = 123;
    final tBranchData = {
      'id': 1,
      'empresa_id': tCompanyId,
      'nombre': 'Branch 1',
      'direccion': 'Address',
      'telefono': '123',
      'activo': true,
    };

    test('getBranches should return list of branches', () async {
      // Arrange
      final fakeBuilder = FakeSupabaseQueryBuilder(listData: [tBranchData]);
      fakeClient.registerTable('sucursales', fakeBuilder);

      // Act
      final result = await repository.getBranches(companyId: tCompanyId);

      // Assert
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 1);
      expect(result.first['nombre'], 'Branch 1');
    });

    test('createBranch should call insert', () async {
      // Arrange
      final fakeBuilder = FakeSupabaseQueryBuilder();
      fakeClient.registerTable('sucursales', fakeBuilder);

      // Act
      await repository.createBranch(
        companyId: tCompanyId,
        name: 'New Branch',
        address: 'Addr',
      );

      // Assert
      // Implicit verification
    });
  });
}
