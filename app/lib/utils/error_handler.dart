import 'package:flutter/material.dart';
import '../core/error/failure.dart';

/// Centralized error and success message handler
/// 
/// Eliminates code duplication across screens for showing
/// error messages and success notifications via SnackBars.
class ErrorHandler {
  /// Shows an error message using a SnackBar
  /// 
  /// Automatically formats known error types (AuthFailure, ServerFailure)
  /// and shows generic error message for unknown types.
  static void showError(BuildContext context, Object error) {
    if (!context.mounted) return;
    
    final message = _formatError(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Shows a success message using a SnackBar
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows an info message using a SnackBar
  static void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Formats error objects into user-friendly messages
  static String _formatError(Object error) {
    if (error is AuthFailure) {
      return error.message;
    }
    if (error is ServerFailure) {
      return error.message;
    }
    // Generic error formatting
    final errorString = error.toString();
    // Remove "Exception: " prefix if present
    if (errorString.startsWith('Exception: ')) {
      return errorString.substring(11);
    }
    return errorString;
  }
}
