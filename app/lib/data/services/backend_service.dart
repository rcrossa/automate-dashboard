import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

/// Service for interacting with Python backend API
/// 
/// Backend provides:
/// - Health check endpoint
/// - Speech-to-text transcription (when Whisper is installed)
class BackendService {
  // Configuration
  // For localhost testing use: 'http://127.0.0.1:8000'
  // For iOS simulator use: 'http://localhost:8000'
  // For Android emulator use: 'http://10.0.2.2:8000'
  // For Android device on same WiFi use: 'http://192.168.X.X:8000'
  static const String _baseUrl = 'http://127.0.0.1:8000';  // Changed to localhost for testing
  static const String _apiKey = 'your-secret-api-key-here'; // TODO: Move to env

  
  // HTTP client with timeout
  final http.Client _client;
  final Duration _timeout;
  
  BackendService({
    http.Client? client,
    Duration timeout = const Duration(seconds: 30),
  })  : _client = client ?? http.Client(),
        _timeout = timeout;
  
  /// Check if backend is reachable and healthy
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/health'),
          )
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw BackendException(
          'Health check failed: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw BackendException(
        'Cannot connect to backend. Is the server running?',
        isConnectivityError: true,
      );
    } on TimeoutException {
      throw BackendException(
        'Backend request timed out',
        isTimeout: true,
      );
    } catch (e) {
      throw BackendException('Health check error: $e');
    }
  }
  
  /// Get backend root info
  Future<Map<String, dynamic>> getInfo() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseUrl))
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw BackendException(
          'Failed to get backend info: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw BackendException('Backend info error: $e');
    }
  }
  
  /// Transcribe audio file to text
  /// 
  /// NOTE: This endpoint requires Whisper to be installed in the backend.
  /// If Whisper is not installed, this will return a 404 error.
  /// 
  /// [audioUrl]: Path to audio file in Supabase Storage (e.g., 'audios/report_123.m4a')
  /// [userId]: User ID making the request
  /// [language]: Optional language code ('es', 'en'). Auto-detect if null.
  Future<TranscriptionResult> transcribeAudio({
    required String audioUrl,
    required String userId,
    String? language,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/v1/transcribe'),
            headers: {
              'Content-Type': 'application/json',
              'X-API-Key': _apiKey,
            },
            body: json.encode({
              'audio_url': audioUrl,
              'user_id': userId,
              if (language != null) 'language': language,
            }),
          )
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return TranscriptionResult.fromJson(data);
      } else if (response.statusCode == 404) {
        throw BackendException(
          'Transcription endpoint not available. Whisper may not be installed.',
          statusCode: 404,
        );
      } else if (response.statusCode == 401) {
        throw BackendException(
          'Invalid API key',
          statusCode: 401,
          isAuthError: true,
        );
      } else {
        throw BackendException(
          'Transcription failed: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw BackendException(
        'Cannot connect to backend',
        isConnectivityError: true,
      );
    } on TimeoutException {
      throw BackendException(
        'Transcription request timed out',
        isTimeout: true,
      );
    } catch (e) {
      if (e is BackendException) rethrow;
      throw BackendException('Transcription error: $e');
    }
  }
  
  /// Transcribe local audio file to text (multipart upload)
  /// 
  /// This method uploads a local audio file directly to the backend
  /// for transcription. Perfect for testing or when audio is recorded locally.
  /// 
  /// [audioFilePath]: Absolute path to audio file (e.g., from RecordAudioButton)
  /// [userId]: User ID making the request  
  /// [language]: Optional language code ('es', 'en'). Auto-detect if null.
  /// [mode]: Transcription mode ('simple' or 'diarization'). Defaults to 'simple'.
  Future<TranscriptionResult> transcribeAudioFile({
    required String audioFilePath,
    required String userId,
    String? language,
    String mode = 'simple',
    int? clienteId,  // Nueva: contexto para diarization
    String? ejecutivoId,  // Nueva: contexto para diarization
  }) async {
    try {
      final audioFile = File(audioFilePath);
      if (!await audioFile.exists()) {
        throw BackendException('Audio file not found: $audioFilePath');
      }

      // Create multipart request with mode parameter
      final uri = Uri.parse('$_baseUrl/api/v1/transcribe').replace(
        queryParameters: {'mode': mode},
      );
      final request = http.MultipartRequest('POST', uri);
    
      // DEBUG: Log the mode being sent
      print('🔍 DEBUG transcribeAudioFile - mode: $mode, clienteId: $clienteId, ejecutivoId: $ejecutivoId');
      
      request.fields['mode'] = mode;
      request.headers['X-API-Key'] = _apiKey;

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFilePath,
          filename: audioFile.uri.pathSegments.last,
        ),
      );

      // Add metadata
      request.fields['user_id'] = userId;
      if (language != null) {
        request.fields['language'] = language;
      }
      
      // Add context for diarization (newimprovement)
      if (clienteId != null) {
        request.fields['cliente_id'] = clienteId.toString();
      }
      if (ejecutivoId != null) {
        request.fields['ejecutivo_id'] = ejecutivoId;
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return TranscriptionResult.fromJson(data);
      } else if (response.statusCode == 404) {
        throw BackendException(
          'Transcription endpoint not available. Whisper may not be installed.',
          statusCode: 404,
        );
      } else if (response.statusCode == 401) {
        throw BackendException(
          'Invalid API key',
          statusCode: 401,
          isAuthError: true,
        );
      } else {
        throw BackendException(
          'Transcription failed: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw BackendException(
        'Cannot connect to backend',
        isConnectivityError: true,
      );
    } on TimeoutException {
      throw BackendException(
        'Transcription request timed out (${_timeout.inSeconds}s)',
        isTimeout: true,
      );
    } catch (e) {
      if (e is BackendException) rethrow;
      throw BackendException('Transcription error: $e');
    }
  }

  /// Transcribe audio and save to database (combined operation)
  /// 
  /// This method combines transcription with database saving for convenience.
  /// It transcribes the audio file and immediately saves the transcription
  /// to the transcripciones_ejecutivo table.
  /// 
  /// Returns the created TranscripcionEjecutivo entity.
  Future<dynamic> transcribeAndSave({
    required String audioFilePath,
    required String userId,
    required String userName,
    required int empresaId,
    int? sucursalId,
    String? userRole,
    int? clienteId,
    String? clienteNombre,
    String? clienteTelefono,
    String? clienteEmail,
    int? reclamoId,
    String tipoGrabacion = 'nota_voz', // 'nota_voz' or 'conversacion'
    required dynamic transcripcionRepository, // TranscripcionRepository
  }) async {
    // Determine transcription mode based on tipo_grabacion
    final mode = tipoGrabacion == 'conversacion' ? 'diarization' : 'simple';
    
    // First, transcribe the audio with context
    final transcriptionResult = await transcribeAudioFile(
      audioFilePath: audioFilePath,
      userId: userId,
      mode: mode,
      // Pass context for better diarization (when in conversation mode)
      clienteId: tipoGrabacion == 'conversacion' ? clienteId : null,
      ejecutivoId: tipoGrabacion == 'conversacion' ? userId : null,
    );

    // Then save to database
    final transcripcion = await transcripcionRepository.createTranscripcion(
      empresaId: empresaId,
      sucursalId: sucursalId,
      ejecutivoId: userId,
      ejecutivoNombre: userName,
      ejecutivoRol: userRole,
      clienteId: clienteId,
      clienteNombre: clienteNombre,
      clienteTelefono: clienteTelefono,
      clienteEmail: clienteEmail,
      reclamoId: reclamoId,
      tipoGrabacion: tipoGrabacion,
      textoTranscrito: transcriptionResult.transcription,
      confidence: transcriptionResult.confidence,
      duracionSegundos: transcriptionResult.durationSeconds,
      idiomaDetectado: transcriptionResult.language,
      // IMPORTANT: Pass diarization data
      segmentosConversacion: transcriptionResult.segments,
      participantes: transcriptionResult.participants,
      numSpeakers: transcriptionResult.numSpeakers,
    );

    return transcripcion;
  }
  
  /// Close HTTP client
  void dispose() {
    _client.close();
  }
}


/// Result from audio transcription
class TranscriptionResult {
  final String transcription;
  final String language;
  final double confidence;
  final double durationSeconds;
  final DateTime createdAt;
  final List<Map<String, dynamic>>? segments; // For diarization (conversation segments)
  final List<Map<String, dynamic>>? participants; // For diarization (speaker info)
  final int? numSpeakers; // For diarization
  
  TranscriptionResult({
    required this.transcription,
    required this.language,
    required this.confidence,
    required this.durationSeconds,
    required this.createdAt,
    this.segments,
    this.participants,
    this.numSpeakers,
  });
  
  factory TranscriptionResult.fromJson(Map<String, dynamic> json) {
    return TranscriptionResult(
      transcription: json['transcription'] as String,
      language: json['language'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      durationSeconds: (json['duration_seconds'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      segments: json['segments'] != null 
          ? List<Map<String, dynamic>>.from(json['segments'] as List)
          : null,
      participants: json['participants'] != null
          ? List<Map<String, dynamic>>.from(json['participants'] as List)
          : null,
      numSpeakers: json['num_speakers'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'transcription': transcription,
      'language': language,
      'confidence': confidence,
      'duration_seconds': durationSeconds,
      'created_at': createdAt.toIso8601String(),
      if (segments != null) 'segments': segments,
      if (participants != null) 'participants': participants,
      if (numSpeakers != null) 'num_speakers': numSpeakers,
    };
  }
}

/// Exception thrown by backend service
class BackendException implements Exception {
  final String message;
  final int? statusCode;
  final bool isConnectivityError;
  final bool isTimeout;
  final bool isAuthError;
  
  BackendException(
    this.message, {
    this.statusCode,
    this.isConnectivityError = false,
    this.isTimeout = false,
    this.isAuthError = false,
  });
  
  @override
  String toString() => 'BackendException: $message';
  
  /// User-friendly error message
  String get userMessage {
    if (isConnectivityError) {
      return 'No se puede conectar al servidor. Verifica que esté corriendo.';
    } else if (isTimeout) {
      return 'La solicitud tardó demasiado. Intenta de nuevo.';
    } else if (isAuthError) {
      return 'Error de autenticación con el servidor.';
    } else if (statusCode == 404) {
      return 'Endpoint no disponible. Puede que el servidor necesite configuración adicional.';
    } else {
      return message;
    }
  }
}
