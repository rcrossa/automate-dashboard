import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class ReclamoCard extends StatelessWidget {
  final Reclamo reclamo;
  final Function(int, String) onEstadoChanged;

  const ReclamoCard({
    super.key,
    required this.reclamo,
    required this.onEstadoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        title: Text(
          reclamo.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reclamo.descripcion != null) Text(reclamo.descripcion!),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildEstadoChip(context, reclamo.estado),
                const SizedBox(width: 8),
                _buildPrioridadChip(context, reclamo.prioridad),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(reclamo.fechaCreacion),
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (estado) => onEstadoChanged(reclamo.id, estado),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'pendiente', child: Text(l10n.statusPending)),
            PopupMenuItem(value: 'en_proceso', child: Text(l10n.statusInProgress)),
            PopupMenuItem(value: 'resuelto', child: Text(l10n.statusResolved)),
            PopupMenuItem(value: 'cerrado', child: Text(l10n.statusClosed)),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoChip(BuildContext context, String estado) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    switch (estado) {
      case 'pendiente': 
        color = Colors.orange; 
        label = l10n.statusPending;
        break;
      case 'en_proceso': 
        color = Colors.blue; 
        label = l10n.statusInProgress;
        break;
      case 'resuelto': 
        color = Colors.green; 
        label = l10n.statusResolved;
        break;
      case 'cerrado': 
        color = Colors.grey; 
        label = l10n.statusClosed;
        break;
      default: 
        color = Colors.grey;
        label = estado.toUpperCase();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPrioridadChip(BuildContext context, String prioridad) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    switch (prioridad) {
      case 'alta': 
        color = Colors.red; 
        label = l10n.priorityHigh;
        break;
      case 'media': 
        color = Colors.orange; 
        label = l10n.priorityMedium;
        break;
      case 'baja': 
        color = Colors.green; 
        label = l10n.priorityLow;
        break;
      default: 
        color = Colors.grey;
        label = prioridad.toUpperCase();
    }
    return Text(
      l10n.priorityDisplay(label.toUpperCase()),
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
    );
  }
}
