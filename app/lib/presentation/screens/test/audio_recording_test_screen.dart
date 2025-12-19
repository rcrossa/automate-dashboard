import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:msasb_app/presentation/widgets/audio/record_audio_button.dart';
import 'package:msasb_app/data/services/backend_service.dart';
import 'package:msasb_app/utils/error_handler.dart';

/// Pantalla de prueba para verificar grabación de audio y transcripción
/// TODO: Esta es una pantalla temporal para testing
/// Integrar en el flujo de claims después de verificar que funciona
class AudioRecordingTestScreen extends StatefulWidget {
  const AudioRecordingTestScreen({super.key});

  @override
  State<AudioRecordingTestScreen> createState() => _AudioRecordingTestScreenState();
}

class _AudioRecordingTestScreenState extends State<AudioRecordingTestScreen> {
  String? _lastRecordingPath;
  double? _fileSizeMB;
  bool _isTranscribing = false;
  String? _transcription;
  String? _transcriptionError;
  String _selectedMode = 'simple'; // Default to simple mode
  
  // Diarization data
  List<Map<String, dynamic>>? _segments;
  int? _numSpeakers;
  
  final _backendService = BackendService();

  @override
  void dispose() {
    _backendService.dispose();
    super.dispose();
  }

  void _handleRecordingComplete(String audioPath) {
    final file = File(audioPath);
    final fileSize = file.lengthSync();
    
    setState(() {
      _lastRecordingPath = audioPath;
      _fileSizeMB = fileSize / (1024 * 1024); // Convert to MB
      _transcription = null; // Reset previous transcription
      _transcriptionError = null;
    });

    final l10n = AppLocalizations.of(context)!;
    ErrorHandler.showSuccess(
      context,
      '${l10n.recordedAudio}: ${_fileSizeMB!.toStringAsFixed(2)} MB',
    );
  }

  Future<void> _transcribeAudio() async {
    if (_lastRecordingPath == null) return;

    setState(() {
      _isTranscribing = true;
      _transcription = null;
      _transcriptionError = null;
    });

    try {
      final result = await _backendService.transcribeAudioFile(
        audioFilePath: _lastRecordingPath!,
        userId: 'test-user', // TODO: Use real user ID from session
        language: 'es',
        mode: _selectedMode, // Use selected mode
      );

      setState(() {
        _transcription = result.transcription;
        _segments = result.segments;
        _numSpeakers = result.numSpeakers;
        _isTranscribing = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ErrorHandler.showSuccess(context, l10n.transcriptionCompleted);
      }
    } on BackendException catch (e) {
      setState(() {
        _transcriptionError = e.userMessage;
        _isTranscribing = false;
      });

      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    } catch (e) {
      setState(() {
        _transcriptionError = e.toString();
        _isTranscribing = false;
      });
      
      if (mounted) {
        ErrorHandler.showError(context, e);
      }
    }
  }

  void _copyToClipboard() {
    if (_transcription != null) {
      Clipboard.setData(ClipboardData(text: _transcription!));
      final l10n = AppLocalizations.of(context)!;
      ErrorHandler.showSuccess(context, l10n.textCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.audioTestTitle),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                l10n.recordingTest,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.audioTestSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              
              const SizedBox(height: 48),
              
              // Selector de modo
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Modo de Transcripción',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'simple',
                            label: Text('Simple'),
                            icon: Icon(Icons.mic),
                          ),
                          ButtonSegment(
                            value: 'diarization',
                            label: Text('Diarization'),
                            icon: Icon(Icons.people),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            _selectedMode = selection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedMode == 'simple'
                            ? '📝 Transcripción rápida (una persona)'
                            : '👥 Identifica múltiples speakers (conversación)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Widget de grabación
              RecordAudioButton(
                onRecordingComplete: _handleRecordingComplete,
                maxDurationSeconds: 120, // 2 minutos para testing
              ),
              
              const SizedBox(height: 48),
              
              // Información de última grabación
              if (_lastRecordingPath != null) ...[
                const Divider(),
                const SizedBox(height: 24),
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n.recordedAudio,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _lastRecordingPath!.split('/').last,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.storage, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Tamaño: ${_fileSizeMB!.toStringAsFixed(2)} MB',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botón de transcribir
                ElevatedButton.icon(
                  onPressed: _isTranscribing ? null : _transcribeAudio,
                  icon: _isTranscribing 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(_isTranscribing ? l10n.transcribing : l10n.transcribeAudio),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // Resultado de transcripción
                if (_transcription != null) ...[
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.transcribe, color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        '${l10n.transcription}:',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _copyToClipboard,
                        icon: const Icon(Icons.copy),
                        tooltip: l10n.copyToClipboard,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: SelectableText(
                      _transcription!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  // Diarization segments
                  if (_segments != null && _segments!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.people, color: Colors.deepPurple, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Segmentos por Speaker ($_numSpeakers ${_numSpeakers == 1 ? 'speaker' : 'speakers'})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._segments!.map((segment) {
                      final speaker = segment['speaker'] as String? ?? 'Unknown';
                      final text = segment['text'] as String? ?? '';
                      final role = segment['role'] as String? ?? '';
                      final start = segment['start'] as num? ?? 0;
                      final end = segment['end'] as num? ?? 0;
                      
                      // Color based on role/speaker
                      final isEjecutivo = role == 'ejecutivo' || speaker == 'SPEAKER_00';
                      final cardColor = isEjecutivo ? Colors.blue.shade50 : Colors.green.shade50;
                      final borderColor = isEjecutivo ? Colors.blue.shade200 : Colors.green.shade200;
                      final icon = isEjecutivo ? Icons.support_agent : Icons.person;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(icon, size: 20, color: isEjecutivo ? Colors.blue.shade700 : Colors.green.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    role.isNotEmpty ? role.toUpperCase() : speaker,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isEjecutivo ? Colors.blue.shade700 : Colors.green.shade700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${start.toStringAsFixed(1)}s - ${end.toStringAsFixed(1)}s',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                text,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],
                
                // Error de transcripción
                if (_transcriptionError != null) ...[
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.transcriptionError}:',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _transcriptionError!,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                Text(
                  l10n.noRecordingsYet,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
      ),
    );
  }
}
