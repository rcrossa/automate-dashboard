import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/interaction_repository_provider.dart';
import 'package:msasb_app/domain/entities/interaccion.dart';
import 'reclamos_usuario_pantalla.dart';
import 'package:msasb_app/widgets/module_guard.dart';
import 'widgets/interaccion_card.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/error_handler.dart';


class DashboardUsuarioPantalla extends ConsumerStatefulWidget {
  final Map<String, dynamic> usuario;

  const DashboardUsuarioPantalla({super.key, required this.usuario});

  @override
  ConsumerState<DashboardUsuarioPantalla> createState() => _DashboardUsuarioPantallaState();
}

class _DashboardUsuarioPantallaState extends ConsumerState<DashboardUsuarioPantalla> {
  List<Interaccion> interacciones = [];
  bool cargando = true;
  final TextEditingController _notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarInteracciones();
  }

  Future<void> cargarInteracciones() async {
    final usuarioId = widget.usuario['id'].toString();
    final empresaId = widget.usuario['empresa_id'] as int;
    try {
      final repo = ref.read(interactionRepositoryProvider);
      final datos = await repo.getInteractions(usuarioId, empresaId: empresaId);
      if (mounted) {
        setState(() {
          interacciones = datos;
          cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => cargando = false);
        ErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> agregarNota() async {
    if (_notaController.text.trim().isEmpty) return;
    
    final usuarioId = widget.usuario['id'].toString();
    final empresaId = widget.usuario['empresa_id'] as int;
    try {
      final repo = ref.read(interactionRepositoryProvider);
      await repo.logInteraction(
        userId: usuarioId,
        empresaId: empresaId,
        typeLegacy: 'nota',
        description: _notaController.text.trim(),
      );
      _notaController.clear();
      if (mounted) Navigator.pop(context); // Cerrar diálogo
      cargarInteracciones(); // Recargar lista
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  void mostrarDialogoNota() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNote),
        content: TextField(
          controller: _notaController,
          decoration: InputDecoration(
            hintText: l10n.notePlaceholder,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
                  child: Text(l10n.close),
                  onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: agregarNota,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;
    final esAdmin = usuario['tipo_perfil'] == 'admin';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.clientFileTitle),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          
          // Header del Perfil
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: esAdmin ? Colors.red.shade100 : Colors.blue.shade200,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: esAdmin ? Colors.red.shade700 : Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario['nombre'] ?? l10n.noName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usuario['email'] ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          (usuario['tipo_perfil'] ?? 'usuario').toUpperCase(),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        backgroundColor: esAdmin ? Colors.red : Colors.blue,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Título de Historial
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.interactionHistory,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    ModuleGuard(
                      moduleCode: 'reclamos',
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReclamosUsuarioPantalla(usuario: widget.usuario),
                            ),
                          );
                        },
                        icon: const Icon(Icons.warning_amber_rounded, size: 18),
                        label: Text(l10n.viewClaims),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange[800],
                          side: BorderSide(color: Colors.orange[800]!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: cargarInteracciones,
                      tooltip: l10n.reload,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de Interacciones
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : interacciones.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noInteractions,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: interacciones.length,
                        itemBuilder: (context, index) {
                          final interaccion = interacciones[index];
                          return InteraccionCard(interaccion: interaccion);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_add_note',
        onPressed: mostrarDialogoNota,
        tooltip: 'Agregar Nota',
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
