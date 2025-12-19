# Backend Python - Speech-to-Text Service

**FastAPI + Whisper** for audio transcription

> 📚 **Ver documentación completa**: [`../documentacion_unificada/modulos/speech-to-text-backend.md`](../documentacion_unificada/modulos/speech-to-text-backend.md)  
> Para arquitectura general, decisiones técnicas y roadmap: [`../documentacion_unificada/`](../documentacion_unificada/)

---
## 🎯 Objetivo

Proveer endpoint REST para:
- Transcribir audios de reportes de ventas
- Convertir grabaciones de reuniones a texto
- Soporte para español e inglés

## 🏗️ Stack Técnico

- **Framework**: FastAPI
- **Speech-to-Text**: OpenAI Whisper (open-source)
- **Base de Datos**: Supabase (via supabase-py)
- **Storage**: Supabase Storage para archivos de audio
- **Deploy**: Railway / Google Cloud Run

## 📁 Estructura

```
backend_python/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app entry point
│   ├── config.py            # Configuration & environment
│   ├── dependencies.py      # Dependency injection
│   ├── models/
│   │   ├── __init__.py
│   │   └── transcription.py # Pydantic models
│   ├── routers/
│   │   ├── __init__.py
│   │   └── transcribe.py    # /transcribe endpoint
│   └── services/
│       ├── __init__.py
│       ├── whisper_service.py
│       └── supabase_service.py
├── requirements.txt
├── .env.example
├── Dockerfile
└── README.md
```

## 🚀 Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Edit .env with your credentials

# Run development server
uvicorn app.main:app --reload --host 0.0.0.0  --port 8000

# Test
curl -X POST "http://localhost:8000/transcribe" \
  -H "Content-Type: application/json" \
  -d '{"audio_url": "storage/path/to/audio.m4a"}'
```

## 📋 Environment Variables

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-service-role-key
WHISPER_MODEL=base  # base, small, medium, large
PORT=8000
ENVIRONMENT=development
```

## 🔌 API Endpoints

### POST /transcribe
Transcribe audio file to text

**Request**:
```json
{
  "audio_url": "storage/audios/report_123.m4a",
  "language": "es",
  "user_id": "uuid"
}
```

**Response**:
```json
{
  "transcription": "Reunión con cliente ABC...",
  "language": "es",
  "confidence": 0.95,
  "duration_seconds": 125,
  "created_at": "2025-12-14T10:00:00Z"
}
```

## 💰 Costos Estimados

| Servicio | Costo/Mes |
|----------|-----------|
| Railway (CPU only, Whisper base) | $7 |
| Supabase Storage (1GB audio) | $0-5 |
| **TOTAL MVP** | **$7-12/mes** |

## 📊 ROI

- **Ahorro**: ~30 min/día × 3 ejecutivos × $20/hora = **$300/mes**
- **Costo**: $12/mes
- **ROI Neto**: **+$288/mes** ✅
