import 'package:flutter/material.dart';

class PermisosEditor extends StatelessWidget {
  final String usuarioId;
  final Set<int> usuarioPermisos;
  final List<dynamic> permisos;
  final Function(int permisoId, bool asignar) onPermisoChange;

  const PermisosEditor({
    super.key,
    required this.usuarioId,
    required this.usuarioPermisos,
    required this.permisos,
    required this.onPermisoChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: permisos.map<Widget>((permiso) {
        final tienePermiso = usuarioPermisos.contains(permiso['id']);
        return FilterChip(
          label: Text(permiso['nombre']),
          selected: tienePermiso,
          onSelected: (asignar) {
            onPermisoChange(permiso['id'], asignar);
          },
        );
      }).toList(),
    );
  }
}
