import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/tipo_interaccion.dart';
import 'package:msasb_app/presentation/providers/crm_config_repository_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'interaction_type_dialog.dart';

class InteractionTypesListView extends ConsumerStatefulWidget {
  const InteractionTypesListView({super.key});

  @override
  ConsumerState<InteractionTypesListView> createState() => _InteractionTypesListViewState();
}

class _InteractionTypesListViewState extends ConsumerState<InteractionTypesListView> {
  late Future<List<TipoInteraccion>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = ref.read(crmConfigRepositoryProvider).getTiposInteraccion();
    });
  }

  Future<void> _openDialog([TipoInteraccion? tipo]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => InteractionTypeDialog(tipo: tipo),
    );
    if (result == true) {
      _refresh();
    }
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => InteractionTypeDialog(),
    );
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<TipoInteraccion>>(
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
              return const Center(child: Text('No hay Tipos de Interacción configurados.'));
            }

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  title: Text(item.nombre),
                  subtitle: Text('ID interno: ${item.id}'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal[100],
                    child: Icon(
                      Icons.history,
                      color: Colors.teal[800],
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
                                 await ref.read(crmConfigRepositoryProvider).deleteTipoInteraccion(item.id);
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
            heroTag: 'create_interaction_type_fab',
            onPressed: () => _showCreateDialog(context),
            tooltip: 'Nuevo Tipo',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
