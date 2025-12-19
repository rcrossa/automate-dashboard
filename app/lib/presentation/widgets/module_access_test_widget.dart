import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_modules_provider.dart';

/// Test widget to verify module access checks
/// 
/// Shows:
/// - Speech-to-Text module status
/// - All available modules for current user
/// 
/// Usage: Add to any screen for testing
class ModuleAccessTestWidget extends ConsumerWidget {
  const ModuleAccessTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSpeech = ref.watch(hasSpeechToTextProvider);
    final availableModules = ref.watch(userAvailableModulesProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Module Access Test',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Speech-to-Text specific check
            Text(
              'Speech-to-Text:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            hasSpeech.when(
              data: (hasModule) => Row(
                children: [
                  Icon(
                    hasModule ? Icons.check_circle : Icons.cancel,
                    color: hasModule ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(hasModule ? 'Access Granted ✅' : 'No Access ❌'),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            
            const Divider(height: 32),
            
            // All available modules
            Text(
              'All Available Modules:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            availableModules.when(
              data: (modules) => modules.isEmpty
                  ? const Text('No modules assigned')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: modules
                          .map((code) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Text(code),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Refresh button
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(hasSpeechToTextProvider);
                ref.invalidate(userAvailableModulesProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
