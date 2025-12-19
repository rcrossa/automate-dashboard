import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msasb_app/domain/entities/interaccion.dart';

class InteraccionCard extends StatelessWidget {
  final Interaccion interaccion;

  const InteraccionCard({super.key, required this.interaccion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
      leading: _getIconForType(interaccion.tipoLegacy ?? 'general'),
        title: Text(
          (interaccion.tipoLegacy ?? 'General').toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (interaccion.descripcion != null) ...[
              const SizedBox(height: 4),
              Text(interaccion.descripcion!),
            ],
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(interaccion.fecha),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconForType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'login':
        return const CircleAvatar(
          backgroundColor: Colors.greenAccent,
          child: Icon(Icons.login, color: Colors.black54, size: 20),
        );
      case 'compra':
        return const CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.shopping_cart, color: Colors.black54, size: 20),
        );
      case 'soporte':
        return const CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.support_agent, color: Colors.black54, size: 20),
        );
      case 'nota':
        return const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.note, color: Colors.white, size: 20),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.info, color: Colors.white, size: 20),
        );
    }
  }
}
