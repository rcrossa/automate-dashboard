import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';

import 'package:msasb_app/domain/entities/reclamo.dart';
import 'widgets/reclamo_card.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/widgets/language_selector.dart';
import 'package:msasb_app/utils/error_handler.dart';

class ReclamosUsuarioPantalla extends ConsumerStatefulWidget {
  final Map<String, dynamic> usuario;

  const ReclamosUsuarioPantalla({super.key, required this.usuario});

  @override
  ConsumerState<ReclamosUsuarioPantalla> createState() => _ReclamosUsuarioPantallaState();
}

class _ReclamosUsuarioPantallaState extends ConsumerState<ReclamosUsuarioPantalla> {
  List<Reclamo> reclamos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarReclamos();
  }

  Future<void> cargarReclamos() async {
    final usuarioId = widget.usuario['id'].toString();
    final empresaId = widget.usuario['empresa_id'] as int;
    try {
      final repo = ref.read(reclamoRepositoryProvider);
      final datos = await repo.getClaims(usuarioId, empresaId: empresaId);
      if (mounted) {
        setState(() {
          reclamos = datos;
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

  Future<void> crearReclamo(String titulo, String descripcion, String prioridad) async {
    final usuarioId = widget.usuario['id'].toString();
    final empresaId = widget.usuario['empresa_id'] as int;
    try {
      final repo = ref.read(reclamoRepositoryProvider);
      await repo.createClaim(
        userId: usuarioId,
        empresaId: empresaId,
        title: titulo,
        description: descripcion,
        priority: prioridad,
      );
      cargarReclamos();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> actualizarEstado(int id, String nuevoEstado) async {
    try {
      final repo = ref.read(reclamoRepositoryProvider);
      await repo.updateStatus(id, nuevoEstado);
      cargarReclamos();
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  void mostrarDialogoNuevoReclamo() {
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    String prioridad = 'media';
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.newClaim),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: l10n.titleLabel),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: l10n.descriptionLabel),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: prioridad,
                decoration: InputDecoration(labelText: l10n.priorityLabel),
                items: [
                  DropdownMenuItem(value: 'baja', child: Text(l10n.priorityLow)),
                  DropdownMenuItem(value: 'media', child: Text(l10n.priorityMedium)),
                  DropdownMenuItem(value: 'alta', child: Text(l10n.priorityHigh)),
                ],
                onChanged: (val) => setState(() => prioridad = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (tituloController.text.isNotEmpty) {
                  crearReclamo(
                    tituloController.text,
                    descripcionController.text,
                    prioridad,
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.claimsTitle(widget.usuario['nombre'] ?? '')),
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : reclamos.isEmpty
              ? Center(child: Text(l10n.noClaims))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: reclamos.length,
                  itemBuilder: (context, index) {
                    final reclamo = reclamos[index];
                    return ReclamoCard(
                      reclamo: reclamo,
                      onEstadoChanged: actualizarEstado,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.newClaim,
        onPressed: mostrarDialogoNuevoReclamo,
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}
