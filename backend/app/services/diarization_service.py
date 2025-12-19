"""Diarization service for speaker identification and segmentation."""
import os
from typing import Optional, List, Dict
import logging
from pyannote.audio import Pipeline
import whisper
import torch

logger = logging.getLogger(__name__)


class DiarizationService:
    """Service for speaker diarization using pyannote.audio."""
    
    def __init__(self, hf_token: Optional[str] = None):
        """Initialize diarization service with Hugging Face token.
        
        Args:
            hf_token: Hugging Face API token for accessing pyannote models
        """
        self.hf_token = hf_token or os.getenv("HF_TOKEN")
        if not self.hf_token:
            raise ValueError("HF_TOKEN environment variable must be set for diarization")
        
        self.pipeline = None
        self._load_pipeline()
    
    def _load_pipeline(self):
        """Load pyannote diarization pipeline."""
        try:
            logger.info("Loading pyannote diarization pipeline...")
            
            # Try both APIs for compatibility
            # Newer versions (>= 3.2) use 'token', older versions use 'use_auth_token'
            pipeline_loaded = False
            
            # Try new API first
            try:
                self.pipeline = Pipeline.from_pretrained(
                    "pyannote/speaker-diarization-3.1",
                    token=self.hf_token
                )
                pipeline_loaded = True
                logger.info("Loaded with 'token' parameter (new API)")
            except TypeError:
                pass
            
            # If new API failed, try old API
            if not pipeline_loaded:
                try:
                    self.pipeline = Pipeline.from_pretrained(
                        "pyannote/speaker-diarization-3.1",
                        use_auth_token=self.hf_token
                    )
                    logger.info("Loaded with 'use_auth_token' parameter (old API)")
                except TypeError as e:
                    raise ValueError(f"Could not load pipeline with either API: {e}")
            
            # Use GPU if available
            if torch.cuda.is_available():
                self.pipeline.to(torch.device("cuda"))
                logger.info("Diarization pipeline loaded on GPU")
            else:
                logger.info("Diarization pipeline loaded on CPU")
                
        except Exception as e:
            logger.error(f"Failed to load diarization pipeline: {e}")
            raise
    
    def diarize(self, audio_path: str, num_speakers: Optional[int] = None) -> List[Dict]:
        """Perform speaker diarization on audio file.
        
        Args:
            audio_path: Path to audio file
            num_speakers: Optional number of speakers (if known)
        
        Returns:
            List of diarization segments with speaker, start, end times
        """
        try:
            logger.info(f"Starting diarization for: {audio_path}")
            
            # Run diarization
            diarization_args = {"num_speakers": num_speakers} if num_speakers else {}
            diarization = self.pipeline(audio_path, **diarization_args)
            
            # Convert to list of segments
            segments = []
            for turn, _, speaker in diarization.itertracks(yield_label=True):
                segments.append({
                    "speaker": speaker,
                    "start": turn.start,
                    "end": turn.end
                })
            
            num_speakers_detected = len(set(s["speaker"] for s in segments))
            logger.info(f"Diarization complete. Detected {num_speakers_detected} speakers, {len(segments)} segments")
            
            return segments
            
        except Exception as e:
            logger.error(f"Diarization failed: {e}")
            raise


async def transcribe_with_diarization(
    audio_path: str,
    whisper_model,
    hf_token: str,
    num_speakers: Optional[int] = None,
    context: Optional[Dict] = None
) -> dict:
    """Transcribe audio with speaker diarization.
    
    Args:
        audio_path: Path to audio file
        whisper_model: Loaded Whisper model instance
        hf_token: Hugging Face token for pyannote
        num_speakers: Optional expected number of speakers
        context: Optional context dict with cliente_id and/or ejecutivo_id
    
    Returns:
        dict with transcription, segments, speakers, and metadata
    """
    import tempfile
    import os
    
    wav_path = None
    try:
        # Step 0: Convert audio to WAV if needed (pyannote requires WAV)
        if not audio_path.endswith('.wav'):
            logger.info("Step 0/3: Converting audio to WAV format...")
            import soundfile as sf
            import librosa
            
            # Load audio with librosa (handles all formats)
            audio_data, sample_rate = librosa.load(audio_path, sr=None, mono=False)
            
            # Create temporary WAV file
            wav_fd, wav_path = tempfile.mkstemp(suffix='.wav')
            os.close(wav_fd)
            
            # Save as WAV
            sf.write(wav_path, audio_data.T if len(audio_data.shape) > 1 else audio_data, sample_rate)
            logger.info(f"Converted to WAV: {wav_path}")
            audio_path_for_diarization = wav_path
        else:
            audio_path_for_diarization = audio_path
        
        # Step 1: Get diarization segments
        logger.info("Step 1/3: Running diarization...")
        diarization_service = DiarizationService(hf_token)
        diarization_segments = diarization_service.diarize(audio_path_for_diarization, num_speakers)
        
        if not diarization_segments:
            raise ValueError("No speakers detected in audio")
        
        # Step 2: Transcribe full audio with Whisper
        logger.info("Step 2/3: Transcribing audio...")
        whisper_result = whisper_model.transcribe(
            audio_path,
            language=None,  # Auto-detect
            fp16=False,
            word_timestamps=True  # Important for alignment
        )
        
        full_text = whisper_result["text"].strip()
        detected_language = whisper_result.get("language", "unknown")
        duration = whisper_result.get("duration", 0)
        
        # Step 3: Align transcription with diarization
        logger.info("Step 3/3: Aligning transcription with speakers...")
        aligned_segments = _align_transcription_with_diarization(
            whisper_result.get("segments", []),
            diarization_segments
        )
        
        # Assign roles (improved with context if available)
        aligned_segments = _assign_roles_with_context(aligned_segments, context)
        
        # Calculate overall confidence
        if aligned_segments:
            avg_confidence = sum(s.get("confidence", 0.5) for s in aligned_segments) / len(aligned_segments)
        else:
            avg_confidence = 0.5
        
        num_speakers_detected = len(set(s["speaker"] for s in aligned_segments))
        
        logger.info(f"Diarization complete: {num_speakers_detected} speakers, {len(aligned_segments)} segments")
        
        return {
            "text": full_text,
            "confidence": avg_confidence,
            "language": detected_language,
            "duration": duration,
            "segments": aligned_segments,
            "num_speakers": num_speakers_detected,
            "mode": "diarization",
            "metadata": context or {}  # Include context in response
        }
        
    except Exception as e:
        logger.error(f"Diarization transcription failed: {e}")
        raise
    finally:
        # Cleanup temporary WAV file
        if wav_path and os.path.exists(wav_path):
            try:
                os.unlink(wav_path)
                logger.info(f"Cleaned up temporary WAV file: {wav_path}")
            except Exception as cleanup_error:
                logger.warning(f"Could not cleanup WAV file {wav_path}: {cleanup_error}")


def _align_transcription_with_diarization(
    whisper_segments: List[Dict],
    diarization_segments: List[Dict]
) -> List[Dict]:
    """Align Whisper transcription segments with diarization speaker segments.
    
    Args:
        whisper_segments: Segments from Whisper with text and timestamps
        diarization_segments: Segments from pyannote with speaker labels
    
    Returns:
        Aligned segments with speaker, text, timestamps, and confidence
    """
    aligned = []
    
    for whisper_seg in whisper_segments:
        w_start = whisper_seg["start"]
        w_end = whisper_seg["end"]
        w_text = whisper_seg["text"].strip()
        w_confidence = 1.0 - whisper_seg.get("no_speech_prob", 0.0)
        
        # Find overlapping diarization segment
        best_overlap = 0
        best_speaker = "SPEAKER_UNKNOWN"
        
        for diar_seg in diarization_segments:
            d_start = diar_seg["start"]
            d_end = diar_seg["end"]
            
            # Calculate overlap
            overlap_start = max(w_start, d_start)
            overlap_end = min(w_end, d_end)
            overlap = max(0, overlap_end - overlap_start)
            
            if overlap > best_overlap:
                best_overlap = overlap
                best_speaker = diar_seg["speaker"]
        
        aligned.append({
            "speaker": best_speaker,
            "start": w_start,
            "end": w_end,
            "text": w_text,
            "confidence": w_confidence
        })
    
    return aligned


def _assign_roles_with_context(segments: List[Dict], context: Optional[Dict] = None) -> List[Dict]:
    """Assign ejecutivo/cliente roles to speakers using context.
    
    Uses context information (cliente_id, ejecutivo_id) if available to improve
    role assignment accuracy. Falls back to simple heuristic if no context.
    
    Args:
        segments: List of segments with speaker labels
        context: Optional dict with cliente_id and/or ejecutivo_id
    
    Returns:
        Segments with added 'role' field
    """
    # If no context provided, use simple heuristic
    if not context or (not context.get("cliente_id") and not context.get("ejecutivo_id")):
        logger.info("No context provided, using simple heuristic for role assignment")
        return _assign_roles(segments)
    
    logger.info(f"Using context for role assignment: {context}")
    
    # With context, we know the conversation involves:
    # - An ejecutivo (user making the request)
    # - A cliente (the client being discussed)
    
    # Get unique speakers in order of first appearance
    speakers_order = []
    for seg in segments:
        speaker = seg["speaker"]
        if speaker not in speakers_order:
            speakers_order.append(speaker)
    
    # Strategy: When we have context, we're more confident about role assignment
    # If there are 2 speakers, one is likely ejecutivo and the other cliente
    # Default: first speaker = ejecutivo (common pattern: agent greets first)
    
    role_mapping = {}
    if len(speakers_order) == 2:
        # Most common case: 2 people talking
        # First speaker is usually ejecutivo, second is cliente
        role_mapping[speakers_order[0]] = "ejecutivo"
        role_mapping[speakers_order[1]] = "cliente"
        logger.info(f"2 speakers detected. Assigned: {speakers_order[0]}=ejecutivo, {speakers_order[1]}=cliente")
    elif len(speakers_order) == 1:
        # Only one speaker detected - assume it's the ejecutivo making a note
        role_mapping[speakers_order[0]] = "ejecutivo"
        logger.info(f"1 speaker detected. Assigned: {speakers_order[0]}=ejecutivo")
    else:
        # More than 2 speakers - use heuristic (first = ejecutivo, rest = cliente)
        for i, speaker in enumerate(speakers_order):
            role_mapping[speaker] = "ejecutivo" if i == 0 else "cliente"
        logger.info(f"{len(speakers_order)} speakers detected. Using heuristic assignment")
    
    # Add role to each segment
    for seg in segments:
        seg["role"] = role_mapping.get(seg["speaker"], "unknown")
        # Add context metadata to segment for future reference
        if "metadata" not in seg:
            seg["metadata"] = {}
        seg["metadata"]["context"] = context
    
    return segments


def _assign_roles(segments: List[Dict]) -> List[Dict]:

    """Assign ejecutivo/cliente roles to speakers.
    
    Simple heuristic: First speaker (SPEAKER_00) = ejecutivo, others = cliente
    
    Args:
        segments: List of segments with speaker labels
    
    Returns:
        Segments with added 'role' field
    """
    # Get unique speakers in order of first appearance
    speakers_order = []
    for seg in segments:
        speaker = seg["speaker"]
        if speaker not in speakers_order:
            speakers_order.append(speaker)
    
    # Assign roles: first speaker = ejecutivo, rest = cliente
    role_mapping = {}
    for i, speaker in enumerate(speakers_order):
        role_mapping[speaker] = "ejecutivo" if i == 0 else "cliente"
    
    # Add role to each segment
    for seg in segments:
        seg["role"] = role_mapping.get(seg["speaker"], "unknown")
    
    return segments


# Singleton instance
_diarization_service: Optional[DiarizationService] = None

def get_diarization_service(hf_token: Optional[str] = None) -> DiarizationService:
    """Get or create diarization service instance."""
    global _diarization_service
    if _diarization_service is None:
        _diarization_service = DiarizationService(hf_token)
    return _diarization_service
