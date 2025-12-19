import 'package:flutter/material.dart';

class PaginacionWidget extends StatelessWidget {
  final int paginaActual;
  final int totalPaginas;
  final Function(int) onPageChanged;

  const PaginacionWidget({
    super.key,
    required this.paginaActual,
    required this.totalPaginas,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page, size: 20),
            onPressed: paginaActual > 0
                ? () => onPageChanged(0)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: paginaActual > 0
                ? () => onPageChanged(paginaActual - 1)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${paginaActual + 1} / $totalPaginas',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: paginaActual < totalPaginas - 1
                ? () => onPageChanged(paginaActual + 1)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.last_page, size: 20),
            onPressed: paginaActual < totalPaginas - 1
                ? () => onPageChanged(totalPaginas - 1)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
