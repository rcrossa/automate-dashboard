import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/tipo_reclamo.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'claim_type_dialog.dart';

class ClaimTypesListView extends ConsumerStatefulWidget {
  const ClaimTypesListView({super.key});

  @override
  ConsumerState<ClaimTypesListView> createState() => _ClaimTypesListViewState();
}

class _ClaimTypesListViewState extends ConsumerState<ClaimTypesListView> {
  late Future<List<TipoReclamo>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = ref.read(crmConfigRepositoryProvider).getTiposReclamo();
    });
  }

  Future<void> _openDialog([TipoReclamo? tipo]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ClaimTypeDialog(tipo: tipo),
    );
    if (result == true) {
      _refresh();
    }
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ClaimTypeDialog(),
    );
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<TipoReclamo>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final list = snapshot.data ?? [];

            if (list.isEmpty) {
              return const Center(child: Text('No hay Tipos de Reclamo configurados.'));
            }

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  title: Text(item.nombre),
                  subtitle: Text(item.descripcion ?? 'Sin descripción'),
                  leading: CircleAvatar(
                    backgroundColor: item.activo ? Colors.green[100] : Colors.grey[300],
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: item.activo ? Colors.green[800] : Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openDialog(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                           final confirm = await showDialog<bool>(
                            context: context, 
                            builder: (context) => AlertDialog(
                               title: const Text('Confirmar eliminar'),
                               content: Text('¿Seguro que deseas eliminar el tipo "${item.nombre}"?'),
                               actions: [
                                 TextButton(onPressed: ()=> Navigator.pop(context, false), child: const Text('Cancelar')),
                                 TextButton(onPressed: ()=> Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                               ],
                            )
                           );

                           if(confirm == true) {
                             try {
                               await ref.read(crmConfigRepositoryProvider).deleteTipoReclamo(item.id);
                               if (context.mounted) {
                                  ErrorMessage.show(context, 'Tipo eliminado correctamente');
                                  _refresh();
                               }
                             } catch (e) {
                               if (context.mounted) ErrorMessage.show(context, 'Error al eliminar: $e', isError: true);
                             }
                           }
                        },
                      ),
                    ],
                  ),
                  onTap: () => _openDialog(item),
                );
              },
            );
          },
        ),
        // FAB positioned at bottom right
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'create_claim_type_fab',
            onPressed: () => _showCreateDialog(context),
            tooltip: 'Nuevo Tipo',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
