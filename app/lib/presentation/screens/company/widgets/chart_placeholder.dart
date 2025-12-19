import 'package:flutter/material.dart';

class ChartPlaceholder extends StatelessWidget {
  final String title;
  final Color bgColor;

  const ChartPlaceholder({
    super.key,
    required this.title,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              color: bgColor,
              child: const Center(
                child: Text('Gráfico Placeholder', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
