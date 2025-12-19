import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/backend_provider.dart';

/// Debug widget to test backend connectivity
/// 
/// Shows backend status and allows testing endpoints
class BackendTestWidget extends ConsumerWidget {
  const BackendTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthCheck = ref.watch(backendHealthProvider);
    final info = ref.watch(backendInfoProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🐍 Python Backend Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Backend Info
            info.when(
              data: (data) => _buildInfoCard(data),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => _buildErrorCard('Info', error),
            ),
            
            const SizedBox(height: 12),
            
            // Health Check
            healthCheck.when(
              data: (data) => _buildHealthCard(data),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _buildErrorCard('Health', error),
            ),
            
            const SizedBox(height: 16),
            
            // Refresh button
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(backendHealthProvider);
                ref.invalidate(backendInfoProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                data['service'] ?? 'Backend',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Version: ${data['version']}'),
          Text('Status: ${data['status']}'),
        ],
      ),
    );
  }

  Widget _buildHealthCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                'Health Check',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Status: ${data['status']}'),
          Text('Whisper Model: ${data['whisper_model']}'),
          Text('Environment: ${data['environment']}'),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String title, Object error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                '$title Error',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.red.shade900, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
