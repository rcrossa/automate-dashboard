import '../../domain/entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getClientes(int empresaId);
  Future<List<Cliente>> searchClientes(int empresaId, String query);
  Future<Cliente?> getClienteById(int id);
  Future<int> bulkCreateClientes(List<Cliente> clientes);
}
