import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class BranchCard extends StatelessWidget {
  final Map<String, dynamic> sucursal;
  final VoidCallback onEdit;

  const BranchCard({
    super.key,
    required this.sucursal,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.store),
        title: Text(sucursal['nombre']),
        subtitle: Text(sucursal['direccion'] ?? l10n.noAddress),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
