"""FastAPI application for Speech-to-Text transcription using Whisper."""
"""Main FastAPI application for Speech-to-Text backend."""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import transcribe

# OpenAPI/Swagger Configuration
app = FastAPI(
    title="Speech-to-Text API",
    description="""
## 🎙️ Speech-to-Text Backend with Dual-Mode Transcription

This API provides audio transcription services using:
- **Whisper AI** for speech-to-text conversion
- **Pyannote.audio** for speaker diarization (optional)

### Features:
- ✅ Simple transcription (fast, single speaker)
- ✅ Diarization mode (speaker identification)
- ✅ Multi-language support (auto-detect or specify)
- ✅ Confidence scoring
- ✅ JSONB support for conversation segments

### Authentication:
All endpoints require `X-API-Key` header.

### Models:
- Whisper: `{model}` 
- Diarization: pyannote/speaker-diarization-3.1
    """.format(model=settings.WHISPER_MODEL),
    version="1.0.0",
    contact={
        "name": "Development Team",
        "email": "dev@msasb.com",
    },
    license_info={
        "name": "Proprietary",
    },
    docs_url="/docs",  # Swagger UI
    redoc_url="/redoc",  # ReDoc UI
    openapi_url="/openapi.json",
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(transcribe.router, prefix="/api/v1", tags=["Transcription"])


@app.get("/", tags=["Health"])
async def root():
    """Root endpoint - API information."""
    return {
        "name": "Speech-to-Text API",
        "version": "1.0.0",
        "status": "online",
        "docs": "/docs",
        "health": "/health",
    }


@app.get("/health", tags=["Health"])
async def health_check():
    """
    Health check endpoint.
    
    Returns server status and configuration info.
    """
    return {
        "status": "healthy",
        "whisper_model": settings.WHISPER_MODEL,
        "environment": settings.ENVIRONMENT,
        "diarization_enabled": settings.HF_TOKEN is not None,
    }
