import 'package:flutter/material.dart';

class RolSelector extends StatelessWidget {
  final int? rolIdActual;
  final Function(int nuevoRolId) onRolChange;

  const RolSelector({super.key, required this.rolIdActual, required this.onRolChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Cambiar rol: '),
        PopupMenuButton<int>(
          icon: const Icon(Icons.edit),
          onSelected: onRolChange,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 1, child: Text('Admin')),
            PopupMenuItem(value: 2, child: Text('Editor')),
            PopupMenuItem(value: 3, child: Text('Autor')),
            PopupMenuItem(value: 4, child: Text('Colaborador')),
            PopupMenuItem(value: 5, child: Text('Suscriptor')),
          ],
        ),
      ],
    );
  }
}
