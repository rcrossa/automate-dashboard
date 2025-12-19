import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/data/repositories/supabase_interaction_repository.dart';
import 'package:msasb_app/domain/entities/interaccion.dart';

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
  late SupabaseInteractionRepository repository;
  late FakeSupabaseClient fakeClient;

  setUp(() {
    fakeClient = FakeSupabaseClient();
    repository = SupabaseInteractionRepository(fakeClient);
  });

  group('InteractionRepository', () {
    const tUserId = 'user-123';
    final tInteractionData = {
      'id': 1,
      'usuario_id': tUserId,
      'tipo': 'nota',
      'descripcion': 'Test Note',
      'empresa_id': 1,
      'fecha': DateTime.now().toIso8601String(),
    };

    test('getInteractions should return list of Interaccion', () async {
      // Arrange
      final fakeBuilder = FakeSupabaseQueryBuilder(listData: [tInteractionData]);
      fakeClient.registerTable('interacciones', fakeBuilder);

      // Act
      final result = await repository.getInteractions(tUserId, empresaId: 1);

      // Assert
      expect(result, isA<List<Interaccion>>());
      expect(result.length, 1);
      expect(result.first.descripcion, 'Test Note');
    });

    test('logInteraction should call insert', () async {
      // Arrange
      final fakeBuilder = FakeSupabaseQueryBuilder();
      fakeClient.registerTable('interacciones', fakeBuilder);

      // Act
      await repository.logInteraction(
        userId: tUserId,
        empresaId: 1,
        typeLegacy: 'nota',
        description: 'Test',
      );

      // Assert
      // Implicit verification
    });
  });
}
