import 'package:flutter/material.dart';

class ErrorMessage {
  static void show(BuildContext context, dynamic messageOrError, {bool isError = true}) {
    if (!context.mounted) return;
    
    final message = messageOrError.toString().replaceAll('Exception: ', '');
    final color = isError ? Colors.red.shade700 : Colors.green.shade700;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, isError: false);
  }
}
