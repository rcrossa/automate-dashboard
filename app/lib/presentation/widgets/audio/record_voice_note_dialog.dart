import 'package:flutter/material.dart';
import 'package:msasb_app/presentation/widgets/audio/record_audio_button.dart';

/// Dialog for recording voice notes
class RecordVoiceNoteDialog extends StatelessWidget {
  final Function(String audioPath) onRecordingComplete;

  const RecordVoiceNoteDialog({
    super.key,
    required this.onRecordingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mic,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Nota de Voz',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Graba un resumen de la conversación',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            RecordAudioButton(
              onRecordingComplete: (audioPath) {
                Navigator.pop(context);
                onRecordingComplete(audioPath);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
