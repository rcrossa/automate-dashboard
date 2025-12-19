# Troubleshooting Diarization Setup

**Fecha:** 2025-12-15  
**Problema:** Diarization no funcionaba por múltiples errores de dependencias

---

## 🐛 Errores Encontrados y Soluciones

### 1. HF_TOKEN no detectado

**Error:**
```
HF_TOKEN environment variable required for diarization mode
```

**Causa:** 
- Código usaba `os.getenv("HF_TOKEN")` en lugar de `settings.HF_TOKEN`

**Solución:**
```python
# ANTES (❌)
hf_token = os.getenv("HF_TOKEN")

# DESPUÉS (✅)
if not settings.HF_TOKEN:
    raise HTTPException(...)
```

**Archivo:** `app/routers/transcribe.py` líneas 144-151

---

### 2. API de pyannote incompatible

**Error:**
```
Pipeline.from_pretrained() got an unexpected keyword argument 'use_auth_token'
```

**Causa:**
- Pyannote cambió API entre versiones
- Versiones viejas usan `use_auth_token`
- Versiones nuevas usan `token`

**Solución:**
Código compatible con ambas versiones:

```python
# Try both APIs for compatibility
pipeline_loaded = False

# Try new API first
try:
    self.pipeline = Pipeline.from_pretrained(
        "pyannote/speaker-diarization-3.1",
        token=self.hf_token
    )
    pipeline_loaded = True
except TypeError:
    pass

# If new API failed, try old API
if not pipeline_loaded:
    self.pipeline = Pipeline.from_pretrained(
        "pyannote/speaker-diarization-3.1",
        use_auth_token=self.hf_token
    )
```

**Archivo:** `app/services/diarization_service.py` líneas 28-57

---

### 3. Términos de uso de HuggingFace no aceptados

**Error:**
```
Access to model pyannote/speaker-diarization-3.1 is restricted
```

**Causa:**
- Modelos de pyannote requieren aceptar términos de uso

**Solución:**
Aceptar términos en HuggingFace para estos 3 modelos:
1. https://huggingface.co/pyannote/speaker-diarization-3.1
2. https://huggingface.co/pyannote/segmentation-3.0
3. https://huggingface.co/pyannote/speaker-diarization-community-1

Click "Agree and access repository" en cada uno.

---

### 4. AudioDecoder is not defined

**Error:**
```
name 'AudioDecoder' is not defined
```

**Causa:**
- Pyannote versiones recientes (>= 3.2) tienen bug con torchcodec
- Falta FFmpeg en el sistema

**Solución:**

**A. Instalar FFmpeg:**
```bash
brew install ffmpeg
```

**B. Usar pyannote 3.1.1 (versión estable):**
```bash
pip install pyannote.audio==3.1.1
```

**C. Instalar dependencias de audio:**
```bash
pip install soundfile torchaudio
```

---

### 5. Conflictos de versiones httpx

**Error:**
```
supabase 2.3.4 requires httpx<0.26,>=0.24, but you have httpx 0.28.1
```

**Causa:**
- Pyannote instaló httpx 0.28.1
- Supabase requiere httpx < 0.26

**Solución:**
```bash
pip install httpx==0.25.2
```

O en `requirements.txt`:
```txt
httpx>=0.23.0  # Let pyannote resolve version
```

---

## 🔧 Instalación Completa desde Cero

### 1. Dependencias del Sistema

```bash
# Mac (Homebrew)
brew install ffmpeg

# Linux (apt)
sudo apt-get install ffmpeg libsndfile1

# Windows (chocolatey)
choco install ffmpeg
```

### 2. Dependencias Python

```bash
cd backend_python
pip install -r requirements.txt
```

### 3. Variables de Entorno

Crear `.env` con:
```bash
HF_TOKEN=hf_xxxxxxxxxxxxx  # Token de HuggingFace
WHISPER_MODEL=medium
# ... otras variables
```

### 4. Aceptar Términos de Uso

Visitar y aceptar:
- pyannote/speaker-diarization-3.1
- pyannote/segmentation-3.0  
- pyannote/speaker-diarization-community-1

### 5. Primera Ejecución

```bash
./start.sh
```

**Primera vez con diarization:**
- Descargará modelos (~2GB)
- Tardará 1-2 minutos
- Siguientes veces: instantáneo (cache)

---

## 📦 Versiones Recomendadas

```txt
pyannote.audio==3.1.1  # Versión estable, no usar >= 3.2
torch>=2.0.0
torchaudio>=2.0.0
soundfile>=0.12.1
httpx==0.25.2  # Compatible con supabase
```

---

## ⚠️ Problemas Conocidos

### pyannote >= 3.2
- Bug con AudioDecoder/torchcodec
- Requiere FFmpeg 7 específico
- **Recomendación:** Usar 3.1.1

### FFmpeg no instalado
- Warning sobre torchcodec al inicio
- Diarization falla con "AudioDecoder not defined"
- **Solución:** Instalar FFmpeg con brew/apt

### HuggingFace Token
- Debe estar en `.env` como `HF_TOKEN`
- Debe tener permisos de lectura
- TOC deben estar aceptados

---

## 🧪 Verificar Instalación

```bash
# Verificar FFmpeg
ffmpeg -version

# Verificar dependencias Python
pip show pyannote.audio torch torchaudio soundfile

# Test de importación
python -c "from pyannote.audio import Pipeline; print('OK')"

# Test de token
python check_env.py  # Debe mostrar HF_TOKEN: Set
```

---

## 📚 Referencias

- Pyannote docs: https://github.com/pyannote/pyannote-audio
- HuggingFace tokens: https://huggingface.co/settings/tokens
- FFmpeg: https://ffmpeg.org/download.html

---

**Última actualización:** 2025-12-15  
**Creado durante:** Sesión de debugging de diarization
