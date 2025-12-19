import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../../domain/entities/cliente.dart';

class SupabaseClienteRepository implements ClienteRepository {
  final SupabaseClient _client;

  SupabaseClienteRepository(this._client);

  @override
  Future<List<Cliente>> getClientes(int empresaId) async {
    try {
      final data = await _client
          .from('clientes')
          .select()
          .eq('empresa_id', empresaId)
          .order('nombre');
      return (data as List).map((e) => Cliente.fromJson(e)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<Cliente>> searchClientes(int empresaId, String query) async {
    try {
      final data = await _client
          .from('clientes')
          .select()
          .eq('empresa_id', empresaId)
          .or('nombre.ilike.%$query%,apellido.ilike.%$query%,documento_identidad.ilike.%$query%')
          .limit(20);
      return (data as List).map((e) => Cliente.fromJson(e)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Cliente?> getClienteById(int id) async {
    try {
      final data = await _client
          .from('clientes')
          .select()
          .eq('id', id)
          .maybeSingle(); // Use maybeSingle to return null if not found
      return data != null ? Cliente.fromJson(data) : null;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> bulkCreateClientes(List<Cliente> clientes) async {
    if (clientes.isEmpty) return 0;
    try {
      final records = clientes.map((c) => c.toJson()).toList();
      // Supabase insert returns list of inserted rows if select() is used, or null/count depending on options.
      // We just want to insert.
      await _client.from('clientes').insert(records);
      return clientes.length;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
