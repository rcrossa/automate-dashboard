import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/presentation/providers/client_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'dart:io';
import 'package:msasb_app/presentation/screens/client/widgets/client_form_dialog.dart';
import 'package:msasb_app/presentation/screens/client/widgets/client_import_dialog.dart';
import 'package:msasb_app/presentation/screens/crm/clients/client_detail_screen.dart' as crm;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:msasb_app/utils/responsive_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:msasb_app/utils/error_handler.dart';

class ClientListScreen extends ConsumerStatefulWidget {
  final int? empresaId; // Optional override for SuperAdmin browsing a specific company

  const ClientListScreen({super.key, this.empresaId});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollController = ScrollController();
  
  List<Cliente> _clientes = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid "modify provider during build" errors if synchronous updates happen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClients(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadClients();
    }
  }

  Future<void> _loadClients({bool refresh = false}) async {
    if (_isLoading) return;
    stateLoading(true);

    try {
      if (refresh) {
        _offset = 0;
        _clientes = [];
        _hasMore = true;
      }

      final session = ref.read(userStateProvider).asData?.value;
      if (session == null) {
        throw Exception('No active session');
      }
      
      // Use override ID if provided (e.g. SuperAdmin viewing a company), otherwise session ID
      final companyId = widget.empresaId ?? session.empresa?.id ?? session.usuario?.empresaId;
      if (companyId == null) {
         throw Exception('No company associated with user');
      }

      // DETERMINAR SI FILTRAMOS POR SUCURSAL
      // Si soy Admin o SuperAdmin, quiero ver TODOS los clientes de la empresa (branchId = null).
      // Si soy empleado normal, solo los de mi sucursal asignada.
      int? branchIdToFilter;
      final isAdmin = session.usuario?.rol == 'admin' || session.usuario?.rol == 'super_admin';
      
      if (!isAdmin) {
        branchIdToFilter = session.sucursal?.id ?? session.usuario?.sucursalId;
      }

      final repo = ref.read(clientRepositoryProvider);
      final newClients = await repo.getClients(
        companyId: companyId,
        branchId: branchIdToFilter,
        searchQuery: _searchCtrl.text.trim(),
        limit: _limit,
        offset: _offset,
      );

      if (mounted) {
        setState(() {
          if (newClients.length < _limit) {
            _hasMore = false;
          }
          _clientes.addAll(newClients);
          _offset += newClients.length;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } finally {
      stateLoading(false);
    }
  }

  Future<void> _exportClients() async {
    if (_isLoading) return;
    stateLoading(true);

    try {
      final session = ref.read(userStateProvider).asData?.value;
      if (session == null) {
        throw Exception('No active session');
      }
      
      // Use override ID if provided (e.g. SuperAdmin viewing a company), otherwise session ID
      final companyId = widget.empresaId ?? session.empresa?.id ?? session.usuario?.empresaId;
      if (companyId == null) {
         throw Exception('No company associated with user');
      }

      // DETERMINAR SI FILTRAMOS POR SUCURSAL
      // Si soy Admin o SuperAdmin, quiero ver TODOS los clientes de la empresa (branchId = null).
      // Si soy empleado normal, solo los de mi sucursal asignada.
      int? branchIdToFilter;
      final isAdmin = session.usuario?.rol == 'admin' || session.usuario?.rol == 'super_admin';
      
      if (!isAdmin) {
        branchIdToFilter = session.sucursal?.id ?? session.usuario?.sucursalId;
      }

      final repo = ref.read(clientRepositoryProvider);
      // Usar getAllClients() que obtiene TODOS los registros sin paginación
      final allClients = await repo.getAllClients(
        companyId: companyId,
        branchId: branchIdToFilter,
        searchQuery: _searchCtrl.text.trim(),
      );

      if (allClients.isEmpty) {
        if (mounted) {
          ErrorHandler.showInfo(context, 'No hay clientes para exportar');
        }
        return;
      }

      // Convert clients to CSV format
      List<List<dynamic>> rows = [];
      // Add header row
      rows.add([
        'ID', 'Tipo Cliente', 'Nombre', 'Apellido', 'Razon Social', 'CUIT', 'Email', 'Telefono',
        'Direccion', 'Documento Identidad', 'Notas', 'Fecha Creacion'
      ]);
      // Add client data
      for (var client in allClients) {
        rows.add([
          client.id,
          client.tipoCliente,
          client.nombre,
          client.apellido,
          client.razonSocial,
          client.cuit,
          client.email,
          client.telefono,
          client.direccion,
          client.documentoIdentidad,
          client.notas,
          client.fechaCreacion.toIso8601String(),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      final bytes = utf8.encode(csv);

      final fileName = 'clientes_${DateTime.now().toIso8601String().split('T')[0]}.csv';
      
      // Para macOS y otras plataformas problemáticas, guardar directamente en Downloads
      String? filePath;
      
      try {
        // Intentar obtener directorio de descargas
        final Directory? downloadsDir = Platform.isMacOS || Platform.isLinux
            ? Directory('/Users/${Platform.environment['USER']}/Downloads')
            : await getDownloadsDirectory();
        
        if (downloadsDir != null && await downloadsDir.exists()) {
          filePath = '${downloadsDir.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ErrorHandler.showSuccess(context, l10n.exportSuccess(filePath));
          }
        } else {
          throw Exception('No se pudo acceder a la carpeta de descargas');
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ErrorHandler.showError(context, l10n.exportError(e.toString()));
        }
      }
     } catch (e) {
       if (mounted) {
         final l10n = AppLocalizations.of(context)!;
         ErrorHandler.showError(context, l10n.exportError(e.toString()));
       }
     } finally {
       stateLoading(false);
     }
  }

  void stateLoading(bool loading) {
    if (mounted) setState(() => _isLoading = loading);
  }

  Future<void> _openForm([Cliente? cliente]) async {
    final session = ref.read(userStateProvider).asData?.value;
    final companyId = widget.empresaId ?? session?.empresa?.id ?? session?.usuario?.empresaId;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ClientFormDialog(
        cliente: cliente, 
        empresaId: companyId, // Explicitly pass the potentially overridden company ID
      ),
    );

    if (result == true) {
      _loadClients(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha del Cliente'),
        actions: [
          // Desktop only: Button with text label
          if (!ResponsiveHelper.isMobile(context))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Nuevo Cliente'),
                onPressed: () => _openForm(),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar Clientes',
            onPressed: _exportClients,
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Importar Clientes',
            onPressed: () async {
               final session = ref.read(userStateProvider).asData?.value;
               if (session == null) return;
               
               final companyId = widget.empresaId ?? session.empresa?.id ?? session.usuario?.empresaId;
               // Filter branch for managers, or null for admins
               // Actually for import, if I am admin, I can probably choose branch or default to null?
               // For simplicity, admins import to "Headquarters" (null sucursalId) or current branch if set?
               // Let's rely on session access.
               final branchId = session.sucursal?.id ?? session.usuario?.sucursalId;

               if (companyId != null) {
                 final result = await showDialog<bool>(
                   context: context,
                   builder: (context) => ClientImportDialog(
                     empresaId: companyId,
                     sucursalId: branchId,
                   ),
                 );
                 if (result == true) {
                   _loadClients(refresh: true);
                 }
               }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadClients(refresh: true),
          ),
        ],
      ),
      // Mobile only: FAB for primary action
      floatingActionButton: ResponsiveHelper.isMobile(context)
          ? FloatingActionButton(
              heroTag: 'add_client_btn',
              onPressed: () => _openForm(),
              tooltip: 'Nuevo Cliente',
              child: const Icon(Icons.add),
            )
          : null,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Buscar Cliente',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    _loadClients(refresh: true);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _loadClients(refresh: true),
            ),
          ),
          Expanded(
            child: _clientes.isEmpty && !_isLoading
                ? const Center(child: Text('No hay clientes registrados'))
                : ResponsiveHelper.isMobile(context)
                    ? _buildMobileList()
                    : _buildDesktopGrid(),
          ),
        ],
      ),
    );
  }

  // Mobile: ListView tradicional
  Widget _buildMobileList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _clientes.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _clientes.length) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }
        return _buildClientTile(_clientes[index]);
      },
    );
  }

  // Desktop/Tablet: Grid con cards más compactos
  Widget _buildDesktopGrid() {
    final isMobile = ResponsiveHelper.isMobile(context);
    return GridView.builder(
      controller: _scrollController,
     padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        childAspectRatio: isMobile ? 2.5 : 3.5, // Even more height on mobile
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _clientes.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _clientes.length) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final client = _clientes[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => crm.ClientDetailScreen(
                    clientId: client.id,
                    clientName: _getDisplayName(client),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildAvatar(client),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDisplayName(client),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtitle(client),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientTile(Cliente client) {
    return ListTile(
      leading: _buildAvatar(client),
      title: Text(_getDisplayName(client)),
      subtitle: Text(_getSubtitle(client)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => crm.ClientDetailScreen(
              clientId: client.id,
              clientName: _getDisplayName(client),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(Cliente client) {
    final displayName = _getDisplayName(client);
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    return CircleAvatar(child: Text(initial));
  }

  String _getDisplayName(Cliente client) {
    final isCompany = client.tipoCliente == 'empresa';
    return isCompany 
        ? (client.razonSocial ?? 'Sin Razón Social') 
        : '${client.nombre} ${client.apellido ?? ''}';
  }

  String _getSubtitle(Cliente client) {
    final isCompany = client.tipoCliente == 'empresa';
    return isCompany
        ? 'Cuit: ${client.cuit ?? ''} | Contacto: ${client.nombre}'
        : (client.email ?? client.telefono ?? 'Sin contacto');
  }
}
