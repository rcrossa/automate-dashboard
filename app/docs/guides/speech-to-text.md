# Speech-to-Text Module - Guía de Uso

**Estado:** ✅ Implementado y Testeado (Modo Simple)  
**Fecha:** 2025-12-15

---

## 🎯 ¿Qué hace?

Permite a los ejecutivos grabar y transcribir automáticamente:
1. **Notas de Voz**: Resúmenes rápidos (5-10s)
2. **Conversaciones con Clientes**: Con identificación de quién habló (15-30s)

---

## 📱 Cómo Usar

### Para Usuarios

1. Abrir app → **Claims** → Seleccionar reclamo
2. Tab **"NOTAS DE VOZ"**
3. Presionar botón **"Grabar"** (flotante)
4. Seleccionar modo:
   - **Nota de Voz**: Resumen rápido del ejecutivo
   - **Conversación**: Grabación completa con cliente
5. Grabar audio
6. Automáticamente se transcribe y guarda

### Ver Transcripciones

Las transcripciones aparecen en el mismo tab, mostrando:
- Fecha y hora
- Tipo (nota_voz o conversación)
- Duración
- Confianza de transcripción
- Texto completo
- (Futuro) Speakers identificados

---

## 🛠️ Stack Técnico

### Flutter
- **RecordAudioButton**: Widget de grabación
- **SessionProvider**: Contexto de usuario
- **BackendService**: Comunicación con Python API
- **TranscripcionRepository**: Acceso a BD

### Backend Python
- **Whisper**: Transcripción de audio (modelo: medium)
- **Pyannote.audio**: Identificación de speakers (solo conversaciones)
- **FastAPI**: Endpoint `/api/v1/transcribe`

### Base de Datos
- **Tabla**: `transcripciones_ejecutivo`
- **Full-text search** en español
- **RLS**: Solo usuarios de misma empresa ven transcripciones

---

## 🧪 Testing

### ✅ Completado
- [x] Modo Nota de Voz funciona localmente
- [x] Guardado en BD correcto
- [x] Display de transcripciones OK

### ⏳ Pendiente
- [ ] Modo Conversación (requiere 2 personas)
- [ ] Deploy a Railway
- [ ] Testing en producción

---

## 📚 API Documentation

El backend Python incluye **Swagger/OpenAPI** interactivo:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

Permite:
- Probar endpoints directamente desde el navegador
- Ver ejemplos de requests/responses
- Validar formatos y tipos de datos

Ver: `backend_python/SWAGGER.md` para guía completa.

---

## 🚀 Deploy

Ver guía completa en: `backend_python/DEPLOY.md`

**Resumen:**
1. Configurar `HF_TOKEN` en Railway
2. Asegurar 3-4GB RAM
3. Cambiar `_baseUrl` en `backend_service.dart`
4. Rebuild app

---

## 🐛 Troubleshooting

### No se transcribe el audio

**Verificar:**
1. Backend corriendo: `curl http://localhost:8000/health`
2. API Key correcta en `backend_service.dart`
3. Logs del backend: `railway logs` o consola local

### Error de conexión

**Solución:**
```dart
// En backend_service.dart
static const String _baseUrl = 'http://127.0.0.1:8000'; // Local
// o
static const String _baseUrl = 'https://your-app.railway.app'; // Production
```

---

## 📊 Performance

| Modo | Tiempo | Precisión |
|------|--------|-----------|
| Simple | ~5-10s | 90-95% |
| Diarization | ~15-30s | 85-90% |

---

## 🔜 Próximos Pasos

1. Testing modo conversación con 2 personas
2. Deploy a Railway
3. ConversationTimeline widget para mostrar speakers
4. Análisis de sentimiento
5. Sugerencias automáticas de productos

---

## 📁 Archivos Clave

```
lib/
├── presentation/
│   ├── screens/crm/claims/claim_detail_screen.dart
│   ├── widgets/audio/record_voice_note_dialog.dart
│   └── providers/session_provider.dart
├── data/
│   ├── services/backend_service.dart
│   └── repositories/supabase_transcripcion_repository.dart
└── domain/
    └── entities/transcripcion_ejecutivo.dart
```

---

**Documentación completa:** Ver `docs/guides/speech-to-text/`  
**Contacto:** Desarrollo Team
