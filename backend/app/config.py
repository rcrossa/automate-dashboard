"""Application configuration and settings."""
from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional

class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str
    
    # Whisper Configuration
    WHISPER_MODEL: str = "base"  # tiny, base, small, medium, large
    
    # Hugging Face Configuration (for diarization)
    HF_TOKEN: Optional[str] = None
    
    # Server
    PORT: int = 8000
    HOST: str = "0.0.0.0"
    ENVIRONMENT: str = "development"
    
    # Security
    API_KEY: str
    
    # Logging
    LOG_LEVEL: str = "INFO"
    
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)

settings = Settings()
