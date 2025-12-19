import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/core/error/failure.dart';
import 'package:msasb_app/domain/repositories/client_repository.dart';
import 'package:msasb_app/domain/entities/cliente.dart';

class SupabaseClientRepository implements ClientRepository {
  final SupabaseClient _client;

  SupabaseClientRepository(this._client);

  @override
  Future<List<Cliente>> getClients({
    required int companyId,
    int? branchId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = _client
          .from('clientes')
          .select('*, sucursales(id, nombre)')  // Include branch data to avoid N+1
          .eq('empresa_id', companyId);

      if (branchId != null) {
        query = query.eq('sucursal_id', branchId);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Búsqueda insensible a mayúsculas en nombre, apellido o email
        query = query.or('nombre.ilike.%$searchQuery%,apellido.ilike.%$searchQuery%,email.ilike.%$searchQuery%');
      }

      final response = await query
          .order('nombre', ascending: true)
          .range(offset, offset + limit - 1);

      return (response as List).map((json) => Cliente.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Cliente?> getClientById(int id) async {
    try {
      final response = await _client
          .from('clientes')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return Cliente.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Cliente> createClient(Cliente cliente) async {
    try {
      final data = cliente.toJson();
      // Removemos ID para que la DB lo genere, y timestamps para que use defaults si es necesario
      // (aunque toJson incluye timestamps, la DB suele manejarlos en insert)
      // Pero si el cliente viene con ID 0, lo quitamos.
      final insertData = Map<String, dynamic>.from(data);
      if (cliente.id == 0) {
        insertData.remove('id');
      }
      insertData.remove('fecha_creacion');
      insertData.remove('actualizado_en');

      final response = await _client
          .from('clientes')
          .insert(insertData)
          .select()
          .single();

      return Cliente.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Cliente> updateClient(Cliente cliente) async {
    try {
      final data = cliente.toJson();
      final updateData = Map<String, dynamic>.from(data);
      updateData.remove('id');
      updateData.remove('fecha_creacion');
      updateData.remove('actualizado_en');

      final response = await _client
          .from('clientes')
          .update(updateData)
          .eq('id', cliente.id)
          .select()
          .single();

      return Cliente.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteClient(int id) async {
    try {
      // Soft delete o Physical delete? 
      // El requerimiento decía "Elimina (o desactiva)".
      // Por consistencia con la implementación CRUD estándar, haré delete físico,
      // pero si el esquema tiene deleted_at (soft delete), debería ser update.
      // Revisando migration: NO hay deleted_at en clientes, solo estado='activo'.
      // Entonces podemos cambiar el estado a 'inactivo' o borrar.
      // Voy a optar por borrar físico para este sprint inicial, o mejor cambiar estado a 'inactivo' si así se prefiere.
      // "Elimina (o desactiva)" -> Optaré por cambiar estado a 'inactivo' para preservar historia.
      
      await _client.from('clientes').update({'estado': 'inactivo'}).eq('id', id);
      
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> bulkCreateClients(List<Cliente> clients) async {
    if (clients.isEmpty) return 0;
    try {
      final records = clients.map((c) {
         final data = c.toJson();
         final map = Map<String, dynamic>.from(data);
         // Remove ID if 0 or placeholder
         if (c.id == 0) map.remove('id');
         // Timestamps often handled by DB defaults, remove strictly if needed or let DB handle
         map.remove('fecha_creacion');
         map.remove('actualizado_en');
         return map;
      }).toList();

      await _client.from('clientes').insert(records);
      return clients.length;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<Cliente>> getAllClients({
    required int companyId,
    int? branchId,
    String? searchQuery,
  }) async {
    try {
      var query = _client
          .from('clientes')
          .select('*, sucursales(id, nombre)')  // Include branch data to avoid N+1
          .eq('empresa_id', companyId);

      if (branchId != null) {
        query = query.eq('sucursal_id', branchId);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('nombre.ilike.%$searchQuery%,apellido.ilike.%$searchQuery%,email.ilike.%$searchQuery%');
      }

      final response = await query.order('nombre', ascending: true); // No range limit

      return (response as List).map((json) => Cliente.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
