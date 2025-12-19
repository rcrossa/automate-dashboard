import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/services/backend_service.dart';

/// Provider for BackendService singleton
final backendServiceProvider = Provider<BackendService>((ref) {
  final service = BackendService(client: http.Client());
  
  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider to check backend health status
final backendHealthProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final backend = ref.watch(backendServiceProvider);
  return backend.healthCheck();
});

/// Provider to get backend info
final backendInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final backend = ref.watch(backendServiceProvider);
  return backend.getInfo();
});
