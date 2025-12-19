import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart' if (dart.library.html) 'package:path_provider/path_provider.dart';


/// Widget para grabar audio con botón y timer
/// 
/// Uso:
/// ```dart
/// RecordAudioButton(
///   onRecordingComplete: (String audioPath) {
///     // Hacer algo con el archivo de audio
///     print('Audio guardado en: $audioPath');
///   },
/// )
/// ```
class RecordAudioButton extends StatefulWidget {
  final Function(String audioPath) onRecordingComplete;
  final int maxDurationSeconds;
  
  const RecordAudioButton({
    super.key,
    required this.onRecordingComplete,
    this.maxDurationSeconds = 300, // 5 minutos máximo
  });

  @override
  State<RecordAudioButton> createState() => _RecordAudioButtonState();
}

class _RecordAudioButtonState extends State<RecordAudioButton> {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  String? _audioPath;

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Get path
        String path;
        if (kIsWeb) {
          // Web: just use a simple name, file will be in memory
          path = 'recording_${DateTime.now().millisecondsSinceEpoch}';
        } else {
          // Mobile/Desktop: use temporary directory
          final directory = await getTemporaryDirectory();
          path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }
        _audioPath = path; // Store the path in the state variable

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 256000,  // Increased from 128k to 256k for better quality
            sampleRate: 48000, // Increased from 44.1k to 48k for better clarity
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _isPaused = false;
          _recordDuration = 0;
        });

        _startTimer();
      } else {
        if (!mounted) return;
        _showPermissionDialog();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar grabación: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });

      // Auto-stop si alcanza duración máxima
      if (_recordDuration >= widget.maxDurationSeconds) {
        _stopRecording();
      }
    });
  }

  Future<void> _pauseRecording() async {
    try {
      await _audioRecorder.pause();
      _timer?.cancel();
      setState(() {
        _isPaused = true;
      });
    } catch (e) {
      _showErrorDialog('Error al pausar: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      _startTimer();
      setState(() {
        _isPaused = false;
      });
    } catch (e) {
      _showErrorDialog('Error al resumir: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _recordDuration = 0;
      });

      if (path != null) {
        widget.onRecordingComplete(path);
      }
    } catch (e) {
      _showErrorDialog('Error al detener grabación: $e');
    }
  }

  Future<void> _cancelRecording() async {
    try {
      _timer?.cancel();
      await _audioRecorder.cancel();

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _recordDuration = 0;
      });
    } catch (e) {
      _showErrorDialog('Error al cancelar: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso Requerido'),
        content: const Text(
          'Se necesita acceso al micrófono para grabar audio. '
          'Por favor, habilita el permiso en la configuración de la app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      // Botón para empezar a grabar
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _startRecording,
            icon: const Icon(Icons.mic, size: 48),
            color: Theme.of(context).colorScheme.primary,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.all(20),
            ),
            tooltip: 'Iniciar grabación',
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca para grabar',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    // UI mientras está grabando
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador visual de grabación
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Punto rojo parpadeante
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _isPaused ? Colors.orange : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _isPaused ? 'PAUSADO' : 'GRABANDO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isPaused ? Colors.orange : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Timer
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),

            const SizedBox(height: 8),

            // Duración máxima
            Text(
              'Máximo: ${_formatDuration(widget.maxDurationSeconds)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 32),

            // Controles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancelar
                IconButton(
                  onPressed: _cancelRecording,
                  icon: const Icon(Icons.close, size: 32),
                  color: Colors.red,
                  tooltip: 'Cancelar',
                ),

                // Pausar/Resumir
                IconButton(
                  onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                  icon: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    size: 32,
                  ),
                  color: Colors.orange,
                  tooltip: _isPaused ? 'Resumir' : 'Pausar',
                ),

                // Detener
                IconButton(
                  onPressed: _stopRecording,
                  icon: const Icon(Icons.stop, size: 32),
                  color: Colors.green,
                  tooltip: 'Finalizar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
