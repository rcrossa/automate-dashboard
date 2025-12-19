# Backend Python - Speech-to-Text API

# Backend Python - Speech-to-Text API

## 📚 Documentación

- **[MODELS.md](./MODELS.md)** - Whisper y HuggingFace: descarga, cache, configuración ⭐ NUEVO
- **[SWAGGER.md](./SWAGGER.md)** - API interactiva (Swagger UI)
- **[README_SPEECH_TO_TEXT.md](./README_SPEECH_TO_TEXT.md)** - Guía completa

---

## 🎙️ Endpoints

### 📚 Swagger/OpenAPI Documentation

El backend incluye **documentación interactiva automática**:

- **Swagger UI**: http://localhost:8000/docs (Interactivo - Probar endpoints)
- **ReDoc**: http://localhost:8000/redoc (Documentación legible)
- **OpenAPI JSON**: http://localhost:8000/openapi.json (Schema programático)

Ver guía completa: [`SWAGGER.md`](./SWAGGER.md)

### Health Check
```bash
GET /health
```

### Transcribe Audio
```bash
POST /api/v1/transcribe?mode=simple|diarization
Headers:
  X-API-Key: your-api-key
Form Data:
  file: audio file (m4a, mp3, wav)
  user_id: string
  language: es|en (optional)
```

---

## 🚀 Inicio Rápido

### Instalación

```bash
# Crear virtualenv
python -m venv venv
source venv/bin/activate  # Mac/Linux
# o
venv\Scripts\activate  # Windows

# Instalar dependencias
pip install -r requirements.txt
```

### Configuración

Crear `.env`:
```bash
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_KEY=eyJhbGc...
WHISPER_MODEL=medium
API_KEY=your-secret-api-key
HF_TOKEN=hf_xxxxx  # Para diarization
PORT=8000
```

### Ejecutar

```bash
./start.sh
# o
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## 📦 Dependencias Principales

- **FastAPI**: Framework web
- **Whisper**: Transcripción (OpenAI)
- **Pyannote.audio**: Speaker diarization
- **Supabase**: Base de datos
- **Torch**: ML backend

---

## 🧪 Testing

```bash
# Health check
curl http://localhost:8000/health

# Transcripción simple
curl -X POST "http://localhost:8000/api/v1/transcribe?mode=simple" \
  -H "X-API-Key: your-api-key" \
  -F "file=@test.m4a" \
  -F "user_id=test-user"

# Con diarization
curl -X POST "http://localhost:8000/api/v1/transcribe?mode=diarization" \
  -H "X-API-Key: your-api-key" \
  -F "file=@conversation.m4a" \
  -F "user_id=test-user"
```

---

## 🚂 Deploy a Railway

1. **Environment Variables:**
   ```
   SUPABASE_URL
   SUPABASE_KEY
   WHISPER_MODEL=medium
   API_KEY
   HF_TOKEN  # IMPORTANTE
   PORT=8000
   ```

2. **Recursos:**
   - RAM: Mínimo 3GB, Recomendado 4GB
   - Razón: Whisper (~1GB) + Pyannote (~2GB)

3. **Verificación:**
   ```bash
   curl https://your-app.railway.app/health
   ```

---

## 🐛 Troubleshooting

### NumPy Version Error
```bash
pip install 'numpy<2.0'
```

### Out of Memory
- Upgrade Railway plan a 4GB
- O usar `WHISPER_MODEL=base` (más pequeño)

### HF_TOKEN Invalid
1. Verificar token en https://huggingface.co/settings/tokens
2. Aceptar TOC: https://huggingface.co/pyannote/speaker-diarization-3.1

---

## 📁 Estructura

```
backend_python/
├── app/
│   ├── main.py              # FastAPI app
│   ├── config.py            # Settings
│   ├── routers/
│   │   └── transcribe.py    # Endpoints
│   ├── services/
│   │   ├── whisper_service.py
│   │   └── diarization_service.py
│   └── models/
│       └── transcription.py
├── requirements.txt
├── start.sh
└── .env
```

---

## 🔜 Roadmap

- [ ] Async processing para audios largos
- [ ] Cache de modelos para startup rápido
- [ ] Batch processing
- [ ] Voice embeddings para reconocimiento recurrente
- [ ] Análisis de sentimiento
- [ ] Sugerencias de productos con IA

---

**Última actualización:** 2025-12-15
