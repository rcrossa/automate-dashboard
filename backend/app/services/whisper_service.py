"""Whisper service for speech-to-text transcription."""
import whisper
import torch
from typing import Optional
import logging

logger = logging.getLogger(__name__)

class WhisperService:
    """Service for loading and using Whisper model."""
    
    def __init__(self, model_name: str = "base"):
        """Initialize Whisper service with specified model.
        
        Args:
            model_name: Whisper model size (tiny, base, small, medium, large)
        """
        self.model_name = model_name
        self.model = None
        self._load_model()
    
    def _load_model(self):
        """Load Whisper model into memory."""
        try:
            logger.info(f"Loading Whisper model: {self.model_name}")
            self.model = whisper.load_model(self.model_name)
            logger.info(f"Whisper model {self.model_name} loaded successfully")
        except Exception as e:
            logger.error(f"Failed to load Whisper model: {e}")
            raise
    
    async def transcribe(
        self,
        audio_path: str,
        language: Optional[str] = None
    ) -> dict:
        """Transcribe audio file to text.
        
        Args:
            audio_path: Path to audio file
            language: Optional language code (es, en, etc.)
        
        Returns:
            dict with transcription, language, and confidence
        """
        try:
            logger.info(f"Transcribing audio: {audio_path}")
            
            # Transcribe with Whisper
            result = self.model.transcribe(
                audio_path,
                language=language,
                fp16=False  # Use FP32 for CPU compatibility
            )
            
            transcription = result["text"].strip()
            detected_language = result.get("language", language or "unknown")
            
            # Calculate average confidence from segments
            segments = result.get("segments", [])
            if segments:
                avg_confidence = sum(s.get("no_speech_prob", 0) for s in segments) / len(segments)
                confidence = 1.0 - avg_confidence  # Invert no_speech_prob
            else:
                confidence = 0.9  # Default confidence if no segments
            
            logger.info(f"Transcription complete. Language: {detected_language}, Confidence: {confidence:.2f}")
            
            return {
                "transcription": transcription,
                "language": detected_language,
                "confidence": confidence,
                "duration": result.get("duration", 0)
            }
            
        except Exception as e:
            logger.error(f"Transcription failed: {e}")
            raise

# Singleton instance
_whisper_service: Optional[WhisperService] = None

def get_whisper_service(model_name: str = "base") -> WhisperService:
    """Get or create Whisper service instance."""
    global _whisper_service
    if _whisper_service is None:
        _whisper_service = WhisperService(model_name)
    return _whisper_service
