import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A Fake Supabase Client that stores data in memory.
class FakeSupabaseDb extends Fake implements SupabaseClient {
  // Storage: Table Name -> List of Rows (each row is a Map)
  final Map<String, List<Map<String, dynamic>>> tables = {};

  FakeSupabaseDb({Map<String, List<Map<String, dynamic>>>? initialData}) {
    if (initialData != null) {
      tables.addAll(initialData);
    }
  }

  @override
  SupabaseQueryBuilder from(String table) {
    if (!tables.containsKey(table)) {
      tables[table] = [];
    }
    return FakeSupabaseQueryBuilder(table, tables);
  }

  @override
  GoTrueClient get auth => FakeGoTrueClient();
}

class FakeGoTrueClient extends Fake implements GoTrueClient {
  @override
  User? get currentUser => const User(
    id: 'test-user-id', 
    appMetadata: {}, 
    userMetadata: {}, 
    aud: 'authenticated', 
    createdAt: '2023-01-01'
  );
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final String _table;
  final Map<String, List<Map<String, dynamic>>> _db;

  FakeSupabaseQueryBuilder(this._table, this._db);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([String columns = '*']) {
    return FakePostgrestFilterBuilder(
      _table, 
      _db, 
      _db[_table] ?? [],
      action: QueryAction.select
    );
  }

  @override
  PostgrestFilterBuilder insert(Object values, {bool defaultToNull = true}) {
    return FakePostgrestFilterBuilder(
      _table, 
      _db, 
      [], // No data selected yet, insert handles its own input
      action: QueryAction.insert,
      inputData: values
    );
  }

  @override
  PostgrestFilterBuilder upsert(Object values, {bool defaultToNull = true, bool ignoreDuplicates = false, String? onConflict}) {
    return FakePostgrestFilterBuilder(
      _table, 
      _db, 
      [], 
      action: QueryAction.upsert,
      inputData: values
    );
  }

  @override
  PostgrestFilterBuilder update(Map values, {bool defaultToNull = true}) {
     return FakePostgrestFilterBuilder(
      _table, 
      _db, 
      _db[_table] ?? [], // We start with all rows, filter them with eq, then update
      action: QueryAction.update,
      inputData: values
    );
  }

  @override
  PostgrestFilterBuilder delete({bool defaultToNull = true}) {
    return FakePostgrestFilterBuilder(
      _table, 
      _db, 
      _db[_table] ?? [],
      action: QueryAction.delete
    );
  }
}

/// Action types for database operations
enum QueryAction { select, insert, update, upsert, delete }

// ignore: must_be_immutable
class FakePostgrestFilterBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  final String _table;
  final Map<String, List<Map<String, dynamic>>> _db;
  final List<Map<String, dynamic>> currentRows; // Renamed from _currentRows to be used
  final QueryAction _action;
  final Object? _inputData;

  // Filters applied
  final List<_Filter> _filters = [];
  
  // Modifiers (mutable state for query building)
  bool _single = false;
  bool _maybeSingle = false;
  int? _limit;
  int? _offset;
  String? _orderBy;
  bool _ascending = true;

  FakePostgrestFilterBuilder(
    this._table, 
    this._db, 
    this.currentRows, 
    {required QueryAction action, Object? inputData}
  ) : _action = action, 
      _inputData = inputData;

  // --- Filters ---

  @override
  PostgrestFilterBuilder<T> eq(String column, Object value) {
    _filters.add(_Filter(column, value, _FilterType.eq));
    return this;
  }
  
  // --- Modifiers ---
  
  @override
  PostgrestTransformBuilder<T> order(String column, {bool ascending = true, bool nullsFirst = false, String? referencedTable}) {
    _orderBy = column;
    _ascending = ascending;
    return FakePostgrestTransformBuilder(this);
  }

  @override
  PostgrestTransformBuilder<T> limit(int count, {String? referencedTable}) {
    _limit = count;
    return FakePostgrestTransformBuilder(this);
  }

  @override
  PostgrestTransformBuilder<T> range(int from, int to, {String? referencedTable}) {
    _offset = from;
    _limit = to - from + 1;
    return FakePostgrestTransformBuilder(this);
  }

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> select([String columns = '*']) {
     // chaining insert(...).select()
     // Create a NEW TransformBuilder typed correctly, wrapping THIS builder but assuming list output
     return FakePostgrestTransformBuilder<List<Map<String, dynamic>>>(this);
  }

  // --- Execution Logic ---

  Future<dynamic> _execute() async {
    List<Map<String, dynamic>> results = [];
    final tableData = _db[_table]!;

    if (_action == QueryAction.insert) {
      final inputList = _inputData is List ? _inputData : [_inputData];
      for (var item in inputList) {
        // Simple insert: append to DB
        final newItem = Map<String, dynamic>.from(item as Map);
        // Simulate generating an ID if not present (simple auto-increment simulation or random)
        if (!newItem.containsKey('id')) {
           newItem['id'] = DateTime.now().millisecondsSinceEpoch; // fallback ID
        }
        tableData.add(newItem);
        results.add(newItem);
      }
    } else if (_action == QueryAction.upsert) {
       final inputList = _inputData is List ? _inputData : [_inputData];
       for (var item in inputList) {
         final mapItem = Map<String, dynamic>.from(item as Map);
         // Naive upsert: if ID exists, remove old, add new. Else add.
         // Real upsert uses onConflict. For mocks, assume ID check.
         if (mapItem.containsKey('id')) {
            tableData.removeWhere((row) => row['id'] == mapItem['id']);
         }
         tableData.add(mapItem);
         results.add(mapItem);
       }
    } else {
      // SELECT, UPDATE, DELETE operate on existing rows filtered by predicates
      results = List.of(tableData);

      // Apply Filters
      for (var filter in _filters) {
        if (filter.type == _FilterType.eq) {
          results = results.where((row) => row[filter.column] == filter.value).toList();
        }
      }

      if (_action == QueryAction.update) {
         final updateData = _inputData as Map;
         for (var row in results) {
           // Update in-memory DB reference
           final index = tableData.indexOf(row);
           if (index != -1) {
             final updatedRow = Map<String, dynamic>.from(row)..addAll(Map<String, dynamic>.from(updateData));
             tableData[index] = updatedRow;
             // Update result list too to return it
             row.addAll(Map<String, dynamic>.from(updateData));
           }
         }
      } else if (_action == QueryAction.delete) {
        for (var row in results) {
          tableData.remove(row);
        }
      }
    }

    // Apply Sorting
    if (_orderBy != null) {
      results.sort((a, b) {
        final valA = a[_orderBy];
        final valB = b[_orderBy];
        if (valA is Comparable && valB is Comparable) {
          return _ascending ? valA.compareTo(valB) : -valB.compareTo(valA);
        }
        return 0;
      });
    }

    // Apply Range/Limit
    if (_offset != null) {
      if (_offset! < results.length) {
         results = results.sublist(_offset!);
      } else {
        results = [];
      }
    }
    if (_limit != null) {
      if (_limit! < results.length) {
        results = results.sublist(0, _limit!);
      }
    }

    // Return Logic
    if (_single) {
      if (results.isEmpty) throw Exception('Row not found');
      return results.first;
    }
    if (_maybeSingle) {
      if (results.isEmpty) return null;
      return results.first;
    }

    return results;
  }

  // --- Future Interface for implicit await ---
  
  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) async {
    final result = await _execute();
    return Future.value(result as T).then(onValue, onError: onError);
  }
}


class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final FakePostgrestFilterBuilder _builder;

  FakePostgrestTransformBuilder(this._builder);

  @override
  PostgrestTransformBuilder<Map<String, dynamic>> single() {
    _builder._single = true;
    return FakePostgrestTransformBuilder<Map<String, dynamic>>(_builder);
  }

  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() {
    _builder._maybeSingle = true;
    // We instantiate with the expected nullable map type for the transformer
    return FakePostgrestTransformBuilder<Map<String, dynamic>?>(_builder);
  }

  // --- Modifiers (delegated back to builder) ---
  @override
  PostgrestTransformBuilder<T> order(String column, {bool ascending = true, bool nullsFirst = false, String? referencedTable}) {
    _builder.order(column, ascending: ascending, nullsFirst: nullsFirst, referencedTable: referencedTable);
    return this;
  }
  
  @override
  PostgrestTransformBuilder<T> limit(int count, {String? referencedTable}) {
     _builder.limit(count, referencedTable: referencedTable);
     return this;
  }

    @override
  PostgrestTransformBuilder<T> range(int from, int to, {String? referencedTable}) {
     _builder.range(from, to, referencedTable: referencedTable);
     return this;
  }

  // --- Future Interface ---

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) async {
    final result = await _builder._execute();
    return Future.value(result as T).then(onValue, onError: onError);
  }
  
  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) async {
    try {
      final result = await _builder._execute();
      return result as T;
    } catch (e) {
      if (test == null || test(e)) {
        return onError(e);
      }
      rethrow;
    }
  }

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) async {
      try {
        final result = await _builder._execute();
        await action();
        return result as T;
      } catch (e) {
        await action();
        rethrow;
      }
  }
}

enum _FilterType { eq }

class _Filter {
  final String column;
  final dynamic value;
  final _FilterType type;
  _Filter(this.column, this.value, this.type);
}
