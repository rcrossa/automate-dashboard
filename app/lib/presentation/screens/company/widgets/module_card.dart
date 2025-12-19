import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

class ModuleCard extends ConsumerWidget {
  final Map<String, dynamic> moduleData;
  final bool isActive;
  final Function(bool) onToggle;
  final VoidCallback onConfigure;

  const ModuleCard({
    super.key,
    required this.moduleData,
    required this.isActive,
    required this.onToggle,
    required this.onConfigure,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final precio = moduleData['precio'] ?? 0;
    
    final session = ref.watch(userStateProvider).asData?.value;
    final esSuperAdmin = session?.isSuperAdmin ?? false;
    final esAdminEmpresa = session?.currentRole == 'admin';
    final puedeEditar = esSuperAdmin || esAdminEmpresa;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (!isActive && puedeEditar) {
            onConfigure();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getIcon(moduleData['icono']),
                    size: 32,
                    color: isActive ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          moduleData['nombre'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          precio == 0 ? 'GRATIS' : '\$$precio / mes',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: precio == 0 ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive,
                    onChanged: puedeEditar ? onToggle : null,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  moduleData['descripcion'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'report_problem': return Icons.report_problem;
      case 'history': return Icons.history;
      case 'inventory': return Icons.inventory;
      default: return Icons.extension;
    }
  }
}
