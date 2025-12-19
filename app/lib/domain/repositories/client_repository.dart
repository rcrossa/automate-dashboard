import 'package:msasb_app/domain/entities/cliente.dart';

abstract class ClientRepository {
  /// Obtiene la lista de clientes paginada
  Future<List<Cliente>> getClients({
    required int companyId,
    int? branchId, // Opcional, si es null trae todos (si tiene permisos)
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  });

  /// Obtiene un cliente por ID
  Future<Cliente?> getClientById(int id);

  /// Crea un nuevo cliente
  Future<Cliente> createClient(Cliente cliente);

  /// Actualiza un cliente existente
  Future<Cliente> updateClient(Cliente cliente);

  /// Elimina (o desactiva) un cliente
  Future<void> deleteClient(int id);

  /// Crea múltiples clientes en lote
  Future<int> bulkCreateClients(List<Cliente> clients);

  /// Obtiene todos los clientes sin paginación (para export)
  Future<List<Cliente>> getAllClients({
    required int companyId,
    int? branchId,
    String? searchQuery,
  });
}
