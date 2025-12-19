"""Debug script to check environment variables."""
from app.config import settings

print("=" * 50)
print("ENVIRONMENT VARIABLES CHECK")
print("=" * 50)

print(f"\n✅ SUPABASE_URL: {'Set' if settings.SUPABASE_URL else 'NOT SET'}")
print(f"✅ SUPABASE_KEY: {'Set' if settings.SUPABASE_KEY else 'NOT SET'}")
print(f"✅ API_KEY: {'Set' if settings.API_KEY else 'NOT SET'}")
print(f"✅ WHISPER_MODEL: {settings.WHISPER_MODEL}")
print(f"{'✅' if settings.HF_TOKEN else '❌'} HF_TOKEN: {'Set (' + settings.HF_TOKEN[:10] + '...)' if settings.HF_TOKEN else 'NOT SET'}")
print(f"\nEnvironment: {settings.ENVIRONMENT}")
print(f"Diarization enabled: {settings.HF_TOKEN is not None}")

print("\n" + "=" * 50)
