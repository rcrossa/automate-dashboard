"""Pydantic models for transcription requests and responses."""
from pydantic import BaseModel, Field
from typing import Optional
from typing import Optional, List
from datetime import datetime

class TranscriptionRequest(BaseModel):
    """Request model for transcription endpoint."""
    audio_url: str = Field(..., description="URL path to audio file in Supabase Storage")
    language: Optional[str] = Field(None, description="Language code (es, en). Auto-detect if not provided")
    user_id: str = Field(..., description="User ID making the request")

class DiarizationSegment(BaseModel):
    """Segment with speaker identification."""
    speaker: str = Field(..., description="Speaker label (SPEAKER_00, SPEAKER_01, etc.)")
    role: Optional[str] = Field(None, description="Assigned role (ejecutivo, cliente)")
    start: float = Field(..., description="Start time in seconds")
    end: float = Field(..., description="End time in seconds")
    text: str = Field(..., description="Transcribed text for this segment")
    confidence: Optional[float] = Field(None, description="Transcription confidence (0-1)")

class TranscriptionResponse(BaseModel):
    """Response model for audio transcription."""
    transcription: str = Field(..., description="Transcribed text")
    language: str = Field(..., description="Detected language code")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Transcription confidence")
    duration_seconds: float = Field(..., description="Audio duration in seconds")
    mode: Optional[str] = Field("simple", description="Transcription mode (simple | diarization)")
    segments: Optional[List[DiarizationSegment]] = Field(None, description="Speaker segments (diarization mode only)")
    num_speakers: Optional[int] = Field(None, description="Number of speakers detected (diarization mode only)")
    created_at: datetime = Field(default_factory=datetime.utcnow, description="Timestamp")
    
class ErrorResponse(BaseModel):
    """Error response model."""
    error: str
