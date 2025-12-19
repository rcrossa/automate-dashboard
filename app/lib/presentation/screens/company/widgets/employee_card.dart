import 'package:flutter/material.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class EmployeeCard extends StatelessWidget {
  final Map<String, dynamic> empleado;
  final VoidCallback onEdit;

  const EmployeeCard({
    super.key,
    required this.empleado,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(empleado['nombre']?[0] ?? '?')),
        title: Text(empleado['nombre'] ?? l10n.noName),
        subtitle: Text('${empleado['email']} \n${l10n.roleBranchLabel(empleado['roles']['nombre'], empleado['sucursales']?['nombre'] ?? l10n.matrix)}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
