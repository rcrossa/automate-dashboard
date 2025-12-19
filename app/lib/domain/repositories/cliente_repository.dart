import '../../domain/entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getClientes();  // Single-tenant: no empresaId needed
  Future<List<Cliente>> searchClientes(String query);  // Single-tenant: no empresaId needed
  Future<Cliente?> getClienteById(int id);
  Future<int> bulkCreateClientes(List<Cliente> clientes);
}
