import 'package:flutter/material.dart';
import '../dashboard_usuario_pantalla.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

class UsuarioCard extends StatelessWidget {
  final Map<String, dynamic> usuario;
  final List<dynamic> roles;
  final List<dynamic> permisosDisponibles;
  final Set<int> permisosUsuario;
  final Function(String, int) onRolChanged;
  final Function(String, int, bool) onPermisoToggled;

  const UsuarioCard({
    super.key,
    required this.usuario,
    required this.roles,
    required this.permisosDisponibles,
    required this.permisosUsuario,
    required this.onRolChanged,
    required this.onPermisoToggled,
  });

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = usuario['id'].toString();
    final rolIdActual = _toInt(usuario['rol_id']);
    final esAdmin = usuario['tipo_perfil'] == 'admin';
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: esAdmin ? Colors.red[100] : Colors.blue[100],
          child: Icon(
            Icons.person,
            size: 20,
            color: esAdmin ? Colors.red[700] : Colors.blue[700],
          ),
        ),
        title: Text(
          usuario['nombre'] ?? l10n.noName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          usuario['email'] ?? '',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: esAdmin ? Colors.red[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                usuario['tipo_perfil'] ?? 'usuario',
                style: TextStyle(
                  fontSize: 11,
                  color: esAdmin ? Colors.red[700] : Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardUsuarioPantalla(usuario: usuario),
                    ),
                  );
                },
                tooltip: l10n.viewFile,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 12),
                // Selector de Rol compacto
                Row(
                  children: [
                    Text(l10n.roleLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: rolIdActual,
                            isExpanded: true,
                            isDense: true,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            items: roles.map<DropdownMenuItem<int>>((rol) {
                              return DropdownMenuItem<int>(
                                value: _toInt(rol['id']),
                                child: Text(rol['nombre'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (nuevoRolId) {
                              if (nuevoRolId != null) {
                                onRolChanged(usuarioId, nuevoRolId);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Permisos compactos
                Text(l10n.permissionsLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: permisosDisponibles.map<Widget>((permiso) {
                    final permisoId = _toInt(permiso['id']) ?? 0;
                    final tienePermiso = permisosUsuario.contains(permisoId);
                    return GestureDetector(
                      onTap: () => onPermisoToggled(usuarioId, permisoId, tienePermiso),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: tienePermiso ? Colors.green[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: tienePermiso ? Colors.green[400]! : Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tienePermiso ? Icons.check_circle : Icons.circle_outlined,
                              size: 14,
                              color: tienePermiso ? Colors.green[700] : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              permiso['nombre'] ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: tienePermiso ? Colors.green[800] : Colors.grey[700],
                                fontWeight: tienePermiso ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
