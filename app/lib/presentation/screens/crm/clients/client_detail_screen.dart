import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msasb_app/domain/entities/cliente.dart';
import 'package:msasb_app/domain/entities/reclamo.dart';
import 'package:msasb_app/domain/entities/transcripcion_ejecutivo.dart';
import 'package:msasb_app/presentation/providers/cliente_repository_provider.dart';
import 'package:msasb_app/presentation/providers/reclamo_repository_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/providers/session_provider.dart';
import 'package:msasb_app/presentation/providers/transcripcion_repository_provider.dart';
import 'package:msasb_app/presentation/widgets/audio/consent_dialog.dart';
import 'package:msasb_app/presentation/widgets/audio/record_voice_note_dialog.dart';
import 'package:msasb_app/presentation/widgets/audio/conversation_timeline.dart';
import 'package:msasb_app/data/services/backend_service.dart';
import 'package:msasb_app/utils/error_message.dart';
import 'package:intl/intl.dart';
import 'package:msasb_app/utils/responsive_helper.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final int clientId;
  final String? clientName; // For app bar until loaded

  const ClientDetailScreen({super.key, required this.clientId, this.clientName});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Cliente? _cliente;
  List<Reclamo> _reclamos = [];
  bool _isLoadingClaims = true;
  List<TranscripcionEjecutivo> _transcripciones = [];
  bool _isLoadingTranscripciones = false;
  int _currentTabIndex = 0;
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Changed to 4 tabs
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      // Reload transcriptions when switching to INTERACCIONES tab
      if (_currentTabIndex == 3 && _transcripciones.isEmpty) {
        _loadTranscripciones();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadTranscripciones();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final clientRepo = ref.read(clienteRepositoryProvider);
      final cliente = await clientRepo.getClienteById(widget.clientId);
      
      if (mounted) {
        setState(() {
          _cliente = cliente;
          _isLoading = false;
        });
        _loadClaims();
      }
    } catch (e) {
      if (mounted) { 
        ErrorMessage.show(context, 'Error cargando cliente: $e', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _loadClaims() async {
    final cliente = _cliente;
    if (cliente == null) return;
    try {
      final claimRepo = ref.read(reclamoRepositoryProvider);
      // We need a way to filter by Client ID in getClaims
      // Currently getClaims filters by user/empresa/query/params.
      // Easiest hack: Use the search query with the client name? No, that's brittle.
      // Correct way: Add clientId param to getClaims properly or filter locally if list is small (no).
      // I will assume for now we use 'query' with the client ID if supported, or I update the repo to support clientId param. 
      // Checking ReclamoRepository previously: it has 'query', 'sucursalId', 'estadoFilter', but NOT 'clientId'.
      // I should update ReclamoRepository interface to support clientId filter. 
      // For now, I'll pass userId of the creator which is not what we want.
      // I will mark this to be improved.
      // Wait, I can search by exact client name? That's what I implemented. 
      // Let's use search by client name for now as a fallback or implemented clientId parameter.
      // I will temporarily implement a search by ClientName using the query param since I added that feature. 
      // But filtering by ID is cleaner. 
      // Let's create `_fetchClaimsByClientId` helper or update repo. 
      // For this step I will assume I rely on the query search I just built.
      
      final claims = await claimRepo.getClaims(
         ref.read(userStateProvider).asData!.value.usuario!.id,
         empresaId: cliente.empresaId,
         clientId: cliente.id,
      );
      if (mounted) setState(() => _reclamos = claims);
      
    } catch(e) {
      debugPrint('Error loading claims: $e');
    } finally {
       if (mounted) setState(() => _isLoadingClaims = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cliente?.tipoCliente == 'empresa' ? (_cliente?.razonSocial ?? 'Cliente') : '${_cliente?.nombre} ${_cliente?.apellido ?? ''}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Reclamos'),
            Tab(text: 'Datos'),
            Tab(text: 'INTERACCIONES', icon: Icon(Icons.mic, size: 18)),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _cliente == null 
           ? const Center(child: Text('Cliente no encontrado'))
           : TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildClaimsTab(),
                _buildDataTab(),
                _buildInteractionsTab(),
              ],
            ),
      floatingActionButton: _currentTabIndex == 3
          ? FloatingActionButton.extended(
              onPressed: _showRecordingModeDialog,
              icon: const Icon(Icons.mic),
              label: const Text('Grabar'),
            )
          : null,
    );
  }
  
  Widget _buildSummaryTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(_cliente!.nombre[0])),
            title: Text('${_cliente!.nombre} ${_cliente!.apellido ?? ''}'),
            subtitle: Text(_cliente!.tipoCliente.toUpperCase()),
          ),
        ),
        const SizedBox(height: 16),
        Row(
           children: [
             _buildStatCard('Total Reclamos', _reclamos.length.toString(), Colors.blue),
             const SizedBox(width: 16),
             _buildStatCard('Pendientes', _reclamos.where((c) => c.estado == 'pendiente').length.toString(), Colors.orange),
           ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: Theme.of(context).primaryColor.withAlpha(25), // Replaced withOpacity with withAlpha(25) for 10% opacity
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             children: [
               Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
               Text(title, style: const TextStyle(fontSize: 14)),
             ],
          ),
        ),
      ),
    );
  }

  Widget _buildClaimsTab() {
     if (_isLoadingClaims) return const Center(child: CircularProgressIndicator());
     if (_reclamos.isEmpty) return const Center(child: Text('Sin reclamos registrados'));
     
     return ListView.builder(
       itemCount: _reclamos.length,
       itemBuilder: (context, index) {
         final claim = _reclamos[index];
         return Card(
           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           child: ListTile(
             leading: _buildStatusIcon(claim.estado),
             title: Text('#${claim.id} ${claim.titulo}'),
             subtitle: Text(DateFormat('dd/MM/yyyy').format(claim.fechaCreacion)),
             trailing: const Icon(Icons.arrow_forward_ios, size: 14),
           ),
         );
       },
     );
  }
  
  Widget _buildStatusIcon(String status) {
    Color c;
    switch(status) {
      case 'pendiente': c = Colors.orange; break;
      case 'resuelto': c = Colors.green; break;
      case 'cerrado': c = Colors.grey; break;
      default: c = Colors.blue;
    }
    return Icon(Icons.circle, color: c, size: 12);
  }

  Widget _buildDataTab() {
    final items = [
      _buildDetailItem('Email', _cliente!.email),
      _buildDetailItem('Teléfono', _cliente!.telefono),
      _buildDetailItem('Dirección', _cliente!.direccion),
      _buildDetailItem('Documento', _cliente!.documentoIdentidad),
      _buildDetailItem('CUIT/NIT', _cliente!.cuit),
      const Divider(),
      _buildDetailItem('Notas', _cliente!.notas),
    ];

    return ResponsiveHelper.isMobile(context)
        ? ListView(padding: const EdgeInsets.all(16), children: items)
        : Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
                      children: items.take(3).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
                      children: items.skip(3).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
  
  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  // ===== VOICE RECORDING METHODS =====

  Future<void> _loadTranscripciones() async {
    final cliente = _cliente;
    if (cliente == null) return;

    setState(() => _isLoadingTranscripciones = true);
    try {
      final repo = ref.read(transcripcionRepositoryProvider);
      final transcripciones = await repo.getTranscripcionesByCliente(cliente.id);
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
          SnackBar(content: Text('Error cargando interacciones: $e')),
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
              subtitle: const Text('Graba un resumen rápido de la interacción'),
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transcribiendo audio...')),
      );

      final session = ref.read(sessionProvider);
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      final transcripcionRepo = ref.read(transcripcionRepositoryProvider);
      final backendService = BackendService();

      await backendService.transcribeAndSave(
        audioFilePath: audioPath,
        userId: session.userId,
        userName: session.userName,
        empresaId: session.empresaId,
        sucursalId: session.sucursalId,
        clienteId: _cliente!.id,
        clienteNombre: _cliente!.tipoCliente == 'empresa' 
            ? _cliente!.razonSocial 
            : '${_cliente!.nombre} ${_cliente!.apellido ?? ''}',
        tipoGrabacion: tipoGrabacion,
        transcripcionRepository: transcripcionRepo,
      );

      await _loadTranscripciones();

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Interacción guardada exitosamente'),
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

  Widget _buildInteractionsTab() {
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
                      'Graba interacciones con el cliente sin crear un reclamo',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lista de interacciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial de Interacciones',
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
                      'No hay interacciones registradas',
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
                                ConversationTimeline(
                                  segments: transcripcion.segmentosConversacion!,
                                  participants: transcripcion.participantes,
                                ),
                              ],
                            )
                          else
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
}
