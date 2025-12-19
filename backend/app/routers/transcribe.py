"""Transcription router - /transcribe endpoint."""
from fastapi import APIRouter, HTTPException, Depends, status, UploadFile, File, Form, Query
from ..models.transcription import TranscriptionResponse, ErrorResponse
from ..services.whisper_service import get_whisper_service
from ..services.diarization_service import transcribe_with_diarization
from ..dependencies import verify_api_key
from ..config import settings
import logging
import os
import tempfile
from datetime import datetime
from typing import Literal, Optional

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post(
    "/transcribe",
    response_model=TranscriptionResponse,
    summary="Transcribe audio to text",
    description="""
    ## Transcribe audio file using Whisper AI with optional speaker diarization.
    
    ### Modes:
    - **simple**: Fast transcription, single text output (5-10s for 30s audio)
    - **diarization**: Speaker identification + transcription (15-30s for 30s audio)
    
    ### Supported Formats:
    - m4a, mp3, wav, flac, ogg, webm
    - Max file size: 25MB
    - Recommended: 16kHz, mono
    
    ### Authentication:
    Requires `X-API-Key` header with valid API key.
    
    ### Diarization Mode Requirements:
    - Backend must have `HF_TOKEN` configured
    - Longer processing time (2-3x slower)
    - Returns additional fields: `segments`, `num_speakers`
    """,
    responses={
        200: {
            "description": "Successful transcription",
            "content": {
                "application/json": {
                    "examples": {
                        "simple_mode": {
                            "summary": "Simple Mode Response",
                            "value": {
                                "transcription": "Hola, necesito ayuda con mi pedido.",
                                "language": "es",
                                "confidence": 0.95,
                                "duration_seconds": 3.2,
                                "mode": "simple",
                                "created_at": "2025-12-15T20:00:00Z"
                            }
                        },
                        "diarization_mode": {
                            "summary": "Diarization Mode Response",
                            "value": {
                                "transcription": "Hola, ¿en qué puedo ayudarle? Necesito ayuda con mi pedido.",
                                "language": "es",
                                "confidence": 0.93,
                                "duration_seconds": 5.8,
                                "mode": "diarization",
                                "num_speakers": 2,
                                "segments": [
                                    {
                                        "speaker": "SPEAKER_00",
                                        "role": "ejecutivo",
                                        "start": 0.0,
                                        "end": 2.5,
                                        "text": "Hola, ¿en qué puedo ayudarle?",
                                        "confidence": 0.96
                                    },
                                    {
                                        "speaker": "SPEAKER_01",
                                        "role": "cliente",
                                        "start": 2.8,
                                        "end": 5.8,
                                        "text": "Necesito ayuda con mi pedido.",
                                        "confidence": 0.91
                                    }
                                ],
                                "created_at": "2025-12-15T20:00:00Z"
                            }
                        }
                    }
                }
            }
        },
        400: {
            "description": "Invalid request (empty file, unsupported format)",
            "model": ErrorResponse
        },
        401: {
            "description": "Invalid or missing API key",
            "model": ErrorResponse
        },
        403: {
            "description": "Diarization mode requires HF_TOKEN",
            "model": ErrorResponse
        },
        500: {
            "description": "Server error during transcription",
            "model": ErrorResponse
        },
    },
    dependencies=[Depends(verify_api_key)],
    tags=["Transcription"]
)
async def transcribe_audio(
    file: UploadFile = File(..., description="Audio file to transcribe (m4a, mp3, wav, etc.)"),
    user_id: str = Form(..., description="User ID making the request", example="user-123"),
    language: str = Form(None, description="Language code (es, en). Auto-detect if omitted", example="es"),
    mode: Literal["simple", "diarization"] = Query(
        "simple", 
        description="Transcription mode: 'simple' (fast) or 'diarization' (speaker ID)",
        example="simple"
    ),
    cliente_id: Optional[int] = Form(None, description="Cliente ID for context (improves diarization accuracy)"),
    ejecutivo_id: Optional[str] = Form(None, description="Ejecutivo/User ID for context (improves diarization accuracy)")
):
    temp_path = None
    
    try:
        # Get Whisper service
        whisper = get_whisper_service(settings.WHISPER_MODEL)
        
        # Create temporary file for audio
        suffix = os.path.splitext(file.filename)[1] or '.m4a'
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
        temp_path = temp_file.name
        
        # Write uploaded file to temp location
        content = await file.read()
        temp_file.write(content)
        temp_file.close()
        
        logger.info(f"Audio saved temporarily: {temp_path} ({len(content)} bytes), mode={mode}")
        print(f"🎙️ TRANSCRIPTION START: {temp_path} ({len(content)} bytes), mode={mode}")
        
        try:
            # Choose transcription method based on mode
            if mode == "diarization":
                # Diarization mode - requires HF_TOKEN
                if not settings.HF_TOKEN:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="HF_TOKEN environment variable required for diarization mode"
                    )
                
                print(f"🎙️ Using DIARIZATION mode with pyannote")
                
                # Build context for diarization
                context = {}
                if cliente_id is not None:
                    context["cliente_id"] = cliente_id
                if ejecutivo_id is not None:
                    context["ejecutivo_id"] = ejecutivo_id
                
                logger.info(f"Diarization context: {context}")
                
                result = await transcribe_with_diarization(
                    audio_path=temp_path,
                    whisper_model=whisper.model,
                    hf_token=settings.HF_TOKEN,
                    context=context if context else None
                )
                
                # Return extended response for diarization
                return {
                    "transcription": result["text"],
                    "language": result["language"],
                    "confidence": result["confidence"],
                    "duration_seconds": result["duration"],
                    "mode": "diarization",
                    "segments": result.get("segments", []),
                    "num_speakers": result.get("num_speakers", 0)
                }
            else:
                # Simple mode - standard Whisper
                print(f"🎙️ Using SIMPLE mode with Whisper")
                result = await whisper.transcribe(temp_path, language)
                
                logger.info(f"Transcription completed for user {user_id}: {len(result['transcription'])} chars")
                
                # Return response
                return TranscriptionResponse(
                    transcription=result["transcription"],
                    language=result["language"],
                    confidence=result["confidence"],
                    duration_seconds=result["duration"],
                    mode="simple"
                )
            
        finally:
            # Always clean up temporary file
            if temp_path and os.path.exists(temp_path):
                os.remove(temp_path)
                logger.debug(f"Cleaned up temporary file: {temp_path}")
    
    except HTTPException:
        # Re-raise HTTP exceptions as-is
        raise
    except Exception as e:
        logger.error(f"Transcription failed: {str(e)}")
        
        # Cleanup on error too
        if temp_path and os.path.exists(temp_path):
            try:
                os.remove(temp_path)
            except:
                pass
        
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Transcription failed: {str(e)}"
        )
