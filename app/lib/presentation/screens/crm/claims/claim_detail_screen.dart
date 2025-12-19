import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/domain/entities/historial_reclamo.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:msasb_app/utils/error_handler.dart';
import 'edit_claim_screen.dart';
import '../clients/client_detail_screen.dart';
import 'package:msasb_app/presentation/widgets/audio/consent_dialog.dart';
import 'package:msasb_app/presentation/widgets/audio/record_voice_note_dialog.dart';
import 'package:msasb_app/presentation/widgets/audio/conversation_timeline.dart';
import 'package:msasb_app/presentation/providers/transcripcion_repository_provider.dart';
import 'package:msasb_app/presentation/providers/session_provider.dart';
import 'package:msasb_app/data/services/backend_service.dart';
import 'package:msasb_app/domain/entities/transcripcion_ejecutivo.dart';

class ClaimDetailScreen extends ConsumerStatefulWidget {
  final Reclamo claim;

  const ClaimDetailScreen({super.key, required this.claim});

  @override
  ConsumerState<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends ConsumerState<ClaimDetailScreen>
    with SingleTickerProviderStateMixin {
  late Reclamo _claim;
  List<HistorialReclamo> _history = [];
  bool _isLoadingHistory = true;
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  late TabController _tabController;
  int _currentTabIndex = 0;
  List<TranscripcionEjecutivo> _transcripciones = [];
  bool _isLoadingTranscripciones = false;

  @override
  void initState() {
    super.initState();
    _claim = widget.claim;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
      _loadTranscripciones();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final repo = ref.read(reclamoRepositoryProvider);
      final history = await repo.getClaimHistory(_claim.id);
      if (mounted) {
        setState(() {
          _history = history;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _loadTranscripciones() async {
    setState(() => _isLoadingTranscripciones = true);
    try {
      final repo = ref.read(transcripcionRepositoryProvider);
      final transcripciones = await repo.getTranscripcionesByReclamo(_claim.id);
      if (mounted) {
        setState(() {
          _transcripciones = transcripciones;
          _isLoadingTranscripciones = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTranscripciones = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando transcripciones: $e')),
        );
      }
    }
  }

  void _showRecordingModeDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selecciona el tipo de grabación',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.mic),
              ),
              title: const Text('Nota de Voz'),
              subtitle: const Text('Graba un resumen rápido de la conversación'),
              onTap: () {
                Navigator.pop(context);
                _startNotaVozRecording();
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.record_voice_over),
              ),
              title: const Text('Conversación Completa'),
              subtitle: const Text('Graba la conversación con el cliente en tiempo real'),
              onTap: () {
                Navigator.pop(context);
                _showConsentAndRecord();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startNotaVozRecording() {
    final session = ref.read(sessionProvider);
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No hay sesión activa')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => RecordVoiceNoteDialog(
        onRecordingComplete: (audioPath) async {
          await _handleRecordingComplete(audioPath, tipoGrabacion: 'nota_voz');
        },
      ),
    );
  }

  void _showConsentAndRecord() {
    final session = ref.read(sessionProvider);
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No hay sesión activa')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ConsentDialog(
        onAccept: () {
          // TODO: Implement conversation recording with diarization
          // For now, just record as nota_voz
          showDialog(
            context: context,
            builder: (context) => RecordVoiceNoteDialog(
              onRecordingComplete: (audioPath) async {
                await _handleRecordingComplete(audioPath, tipoGrabacion: 'conversacion');
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRecordingComplete(
    String audioPath, {
    required String tipoGrabacion,
  }) async {
    try {
      // Show loading
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transcribiendo audio...')),
      );

      // Get session data
      final session = ref.read(sessionProvider);
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      // Get repository
      final transcripcionRepo = ref.read(transcripcionRepositoryProvider);
      final backendService = BackendService();

      // Transcribe and save
      await backendService.transcribeAndSave(
        audioFilePath: audioPath,
        userId: session.userId,
        userName: session.userName,
        empresaId: session.empresaId,
        sucursalId: session.sucursalId,
        reclamoId: _claim.id,
        clienteId: _claim.clienteId,
        clienteNombre: null, // TODO: Get from claim if available
        tipoGrabacion: tipoGrabacion, // IMPORTANT: Pass tipo for proper transcription mode
        transcripcionRepository: transcripcionRepo,
      );

      // Reload transcriptions
      await _loadTranscripciones();

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Transcripción guardada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamo #${_claim.id}'),
        actions: [
          // Only show delete button for supervisors and gerentes
          Consumer(
            builder: (context, ref, child) {
              final session = ref.watch(sessionProvider);
              if (session?.canDeleteClaim ?? false) {
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar Reclamo'),
                        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        final localContext = context;
                        await ref.read(reclamoRepositoryProvider).deleteClaim(_claim.id);
                        if (localContext.mounted) {
                          Navigator.pop(localContext);
                          final l10n = AppLocalizations.of(localContext)!;
                          ErrorHandler.showSuccess(localContext, l10n.claimDeleteSuccess);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ErrorMessage.show(context, 'Error: $e', isError: true);
                        }
                      }
                    }
                  },
                );
              }
              return const SizedBox.shrink(); // No button for staff users
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditClaimScreen(claim: _claim),
                ),
              );

              if (updated == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'DETALLE', icon: Icon(Icons.info)),
            Tab(text: 'HISTORIAL', icon: Icon(Icons.history)),
            Tab(text: 'NOTAS DE VOZ', icon: Icon(Icons.mic)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailTab(),
          _buildHistoryTab(),
          _buildVoiceNotesTab(),
        ],
      ),
      floatingActionButton: _currentTabIndex == 2
          ? FloatingActionButton.extended(
              onPressed: _showRecordingModeDialog,
              icon: const Icon(Icons.mic),
              label: const Text('Grabar'),
            )
          : null,
    );
  }

  Widget _buildDetailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado y Prioridad
          Row(
            children: [
              _buildStatusChip(_claim.estado),
              const SizedBox(width: 8),
              _buildPriorityChip(_claim.prioridad),
              const SizedBox(width: 8),
              _buildUrgenciaChip(_claim.urgencia ?? 'media'),
            ],
          ),
          const SizedBox(height: 16),

          // Título
          Text(
            _claim.titulo,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),

          // Descripción
          if (_claim.descripcion != null)
            Text(
              _claim.descripcion!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const SizedBox(height: 16),

          // Cliente
          if (_claim.clienteId != null)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Cliente'),
              subtitle: Text('ID: ${_claim.clienteId}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (_claim.clienteId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClientDetailScreen(clientId: _claim.clienteId!),
                    ),
                  );
                }
              },
            ),

          const Divider(),

          // Fechas
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Fecha de Creación'),
            subtitle: Text(dateFormat.format(_claim.fechaCreacion)),
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Última Actualización'),
            subtitle: Text(dateFormat.format(_claim.fechaActualizacion)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_history.isEmpty) {
      return const Center(child: Text('No hay historial registrado.'));
    }

    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(entry.descripcion ?? 'Sin descripción'),
          subtitle: Text(dateFormat.format(entry.fecha)),
        );
      },
    );
  }

  Widget _buildVoiceNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Graba notas de voz o conversaciones completas con clientes',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lista de transcripciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transcripciones',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_transcripciones.isNotEmpty)
                Text(
                  '${_transcripciones.length} total',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Loading or content
          if (_isLoadingTranscripciones)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_transcripciones.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.mic_none, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay transcripciones aún',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Presiona el botón "Grabar" para comenzar',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._transcripciones.map((transcripcion) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: transcripcion.tipoGrabacion == 'conversacion'
                        ? Colors.green.shade600
                        : Colors.blue.shade600,
                    child: Icon(
                      transcripcion.tipoGrabacion == 'conversacion'
                          ? Icons.record_voice_over
                          : Icons.mic,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    transcripcion.tipoGrabacion == 'conversacion'
                        ? 'Conversación'
                        : 'Nota de Voz',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(transcripcion.fechaCreacion),
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      if (transcripcion.duracionSegundos != null)
                        Text(
                          'Duración: ${transcripcion.duracionSegundos!.toInt()}s',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                      // Show speaker count for conversations
                      if (transcripcion.tipoGrabacion == 'conversacion' && transcripcion.numSpeakers != null)
                        Text(
                          '${transcripcion.numSpeakers} participantes',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (transcripcion.confidence != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getConfidenceColor(transcripcion.confidence!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(transcripcion.confidence! * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show diarized conversation or simple text
                          if (transcripcion.tipoGrabacion == 'conversacion' &&
                              transcripcion.segmentosConversacion != null &&
                              transcripcion.segmentosConversacion!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    Icon(Icons.people, size: 16, color: Colors.green.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Conversación Diarizada',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Timeline
                                ConversationTimeline(
                                  segments: transcripcion.segmentosConversacion!,
                                  participants: transcripcion.participantes,
                                ),
                              ],
                            )
                          else
                            // Simple transcription text (nota_voz)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transcripcion.textoTranscrito,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          
                          // Metadata
                          if (transcripcion.ejecutivoNombre != null) ...[
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Grabado por: ${transcripcion.ejecutivoNombre}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          
                          if (transcripcion.idiomaDetectado != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.language, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Idioma: ${transcripcion.idiomaDetectado}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pendiente':
        color = Colors.orange;
        break;
      case 'en_proceso':
        color = Colors.blue;
        break;
      case 'resuelto':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(status.toUpperCase()),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color.withValues(alpha: 1.0)),
    );
  }

  Widget _buildPriorityChip(String priority) {
    return Chip(
      label: Text('P: $priority'),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildUrgenciaChip(String urgencia) {
    Color color;
    switch (urgencia) {
      case 'alta':
        color = Colors.redAccent;
        break;
      case 'baja':
        color = Colors.greenAccent;
        break;
      default:
        color = Colors.orangeAccent;
    }
    return Chip(
      label: Text('U: $urgencia', style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color.withValues(alpha: 0.2),
    );
  }
}
