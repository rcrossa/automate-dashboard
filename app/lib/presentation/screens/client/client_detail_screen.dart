import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/providers/client_repository_provider.dart';
import 'package:msasb_app/presentation/screens/client/widgets/client_form_dialog.dart';
import 'package:msasb_app/utils/error_handler.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final Cliente cliente;

  const ClientDetailScreen({super.key, required this.cliente});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  late Cliente _cliente;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
  }

  Future<void> _editClient() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ClientFormDialog(cliente: _cliente),
    );

    if (result == true) {
      _loadLatestData();
    }
  }

  Future<void> _loadLatestData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(clientRepositoryProvider);
      final updated = await repo.getClientById(_cliente.id);
      if (updated != null && mounted) {
        setState(() => _cliente = updated);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteClient() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este cliente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(clientRepositoryProvider).deleteClient(_cliente.id);
        if (mounted) {
          Navigator.pop(context, true); // Return true to refresh list
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showError(context, e);
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_cliente.nombre} ${_cliente.apellido ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _isLoading ? null : _editClient,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteClient,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Información Personal'),
                  _buildInfoRow(Icons.email, 'Email', _cliente.email),
                  _buildInfoRow(Icons.phone, 'Teléfono', _cliente.telefono),
                  _buildInfoRow(Icons.location_on, 'Dirección', _cliente.direccion),
                  _buildInfoRow(Icons.badge, 'Documento', _cliente.documentoIdentidad),
                  
                  const Divider(height: 30),
                  
                  _buildSectionHeader('Estado'),
                  Row(
                    children: [
                      Icon(
                        _cliente.estado == 'activo' ? Icons.check_circle : Icons.cancel,
                        color: _cliente.estado == 'activo' ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _cliente.estado.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  _buildSectionHeader('Notas'),
                  if (_cliente.notas != null && _cliente.notas!.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_cliente.notas!),
                      ),
                    )
                  else
                    const Text('No hay notas registradas.', style: TextStyle(fontStyle: FontStyle.italic)),

                  // TODO: En futuros sprints, agregar historial de interacciones y reclamos aquí.
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
