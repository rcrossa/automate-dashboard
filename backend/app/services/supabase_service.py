"""Supabase service for database operations."""
from supabase import create_client, Client
import logging

logger = logging.getLogger(__name__)

class SupabaseService:
    """Service for interacting with Supabase (database only)."""
    
    def __init__(self, url: str, key: str):
        """Initialize Supabase client.
        
        Args:
            url: Supabase project URL
            key: Supabase service role key
        """
        self.client: Client = create_client(url, key)
        logger.info("Supabase client initialized")
    
    async def save_transcription(
        self,
        user_id: str,
        original_filename: str,
        transcription: str,
        language: str,
        confidence: float,
        duration: float
    ) -> dict:
        """Save transcription to database.
        
        Args:
            user_id: User ID
            original_filename: Original audio filename
            transcription: Transcribed text
            language: Detected language
            confidence: Confidence score
            duration: Audio duration
        
        Returns:
            Inserted record
        """
        try:
            data = {
                "user_id": user_id,
                "original_filename": original_filename,
                "transcription": transcription,
                "language": language,
                "confidence": confidence,
                "duration_seconds": duration
            }
            
            result = self.client.table("transcriptions").insert(data).execute()
            logger.info(f"Transcription saved for user {user_id}")
            
            return result.data[0] if result.data else {}
            
        except Exception as e:
            logger.error(f"Failed to save transcription: {e}")
            raise

# Singleton instance
_supabase_service = None

def get_supabase_service(url: str, key: str):
    """Get or create Supabase service instance."""
    global _supabase_service
    if _supabase_service is None:
        _supabase_service = SupabaseService(url, key)
    return _supabase_service

from supabase import create_client, Client
import logging
from typing import Optional
import aiofiles
import os

logger = logging.getLogger(__name__)

class SupabaseService:
    """Service for interacting with Supabase."""
    
    def __init__(self, url: str, key: str):
        """Initialize Supabase client.
        
        Args:
            url: Supabase project URL
            key: Supabase service role key
        """
        self.client: Client = create_client(url, key)
        logger.info("Supabase client initialized")
    
    async def download_audio(
        self,
        storage_path: str,
        local_path: str
    ) -> str:
        """Download audio file from Supabase Storage.
        
        Args:
            storage_path: Path in Supabase Storage (e.g., 'audios/file.m4a')
            local_path: Local path to save file
        
        Returns:
            Path to downloaded file
        """
        try:
            logger.info(f"Downloading audio from storage: {storage_path}")
            
            # Extract bucket name from path (assuming format: bucket/path/to/file)
            parts = storage_path.split('/', 1)
            bucket_name = parts[0] if len(parts) > 1 else 'audios'
            file_path = parts[1] if len(parts) > 1 else storage_path
            
            # Download file
            response = self.client.storage.from_(bucket_name).download(file_path)
            
            # Save to local file
            os.makedirs(os.path.dirname(local_path), exist_ok=True)
            async with aiofiles.open(local_path, 'wb') as f:
                await f.write(response)
            
            logger.info(f"Audio downloaded to: {local_path}")
            return local_path
            
        except Exception as e:
            logger.error(f"Failed to download audio: {e}")
            raise
    
    async def save_transcription(
        self,
        user_id: str,
        audio_url: str,
        transcription: str,
        language: str,
        confidence: float,
        duration: float
    ) -> dict:
        """Save transcription to database.
        
        Args:
            user_id: User ID
            audio_url: Original audio URL
            transcription: Transcribed text
            language: Detected language
            confidence: Confidence score
            duration: Audio duration
        
        Returns:
            Inserted record
        """
        try:
            data = {
                "user_id": user_id,
                "audio_url": audio_url,
                "transcription": transcription,
                "language": language,
                "confidence": confidence,
                "duration_seconds": duration
            }
            
            result = self.client.table("transcriptions").insert(data).execute()
            logger.info(f"Transcription saved for user {user_id}")
            
            return result.data[0] if result.data else {}
            
        except Exception as e:
            logger.error(f"Failed to save transcription: {e}")
            raise

# Singleton instance
_supabase_service: Optional[SupabaseService] = None

def get_supabase_service(url: str, key: str) -> SupabaseService:
    """Get or create Supabase service instance."""
    global _supabase_service
    if _supabase_service is None:
        _supabase_service = SupabaseService(url, key)
    return _supabase_service
