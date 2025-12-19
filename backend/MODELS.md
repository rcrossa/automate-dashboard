# Modelos y Configuración - Speech-to-Text

**Última actualización:** 2025-12-15

---

## 🎙️ Whisper (Transcripción)

### Descarga Automática

Los modelos se descargan **automáticamente** la primera vez que inicias el backend:

```bash
./start.sh
# Primera vez: Descarga modelo (~2-3 min)
# Siguientes veces: Uso instantáneo ✅
```

### Ubicación Cache

```
~/.cache/whisper/
├── tiny.pt      (~75 MB)
├── base.pt      (~150 MB)
├── small.pt     (~500 MB)
├── medium.pt    (~1.5 GB)  ⭐ Default
└── large.pt     (~3 GB)
```

### Modelos Disponibles

| Modelo | Tamaño | RAM | Velocidad | Precisión | Uso |
|--------|--------|-----|-----------|-----------|-----|
| tiny | 75 MB | 1 GB | Muy rápido | 70% | Testing |
| base | 150 MB | 1 GB | Rápido | 80% | Development |
| small | 500 MB | 2 GB | Medio | 85% | Production básica |
| **medium** | 1.5 GB | 4 GB | Lento | **90-95%** | **Production ⭐** |
| large | 3 GB | 8 GB | Muy lento | 95%+ | Máxima precisión |

### Configuración

```bash
# .env
WHISPER_MODEL=medium  # Cambiar según necesidad
```

**Notas:**
- ❌ No requiere credenciales
- ✅ Funciona offline (después de descarga)
- ✅ Modelos se comparten entre proyectos

---

## 🤗 Hugging Face (Diarización)

### ¿Qué hace?

Identifica **quién habla** en conversaciones:
- Separa por speakers (SPEAKER_00, SPEAKER_01)
- Detecta cambios de voz
- Timestamps de cada intervención

### Modelos Utilizados

1. **pyannote/speaker-diarization-3.1** (~1.5 GB)
   - Pipeline principal
   - Identifica speakers

2. **pyannote/segmentation-3.0** (~500 MB)
   - Detecta cambios de speaker
   - Segmentación de audio

**Total:** ~2 GB

### Setup Requerido

#### 1. Crear Cuenta Hugging Face

https://huggingface.co/join (Gratis)

#### 2. Obtener Token

1. Ir a: https://huggingface.co/settings/tokens
2. Click "New token"
3. Tipo: "Read"
4. Copiar token (formato: `hf_xxxxxxxxxxxxx`)

#### 3. Aceptar Términos de Uso

**IMPORTANTE:** Debes aceptar los términos de estos modelos:

- ✅ https://huggingface.co/pyannote/speaker-diarization-3.1
- ✅ https://huggingface.co/pyannote/segmentation-3.0

Click en "Agree and access repository" en cada uno.

#### 4. Configurar Token

```bash
# .env
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxx
```

### Descarga de Modelos

**Primera ejecución con diarization:**

```bash
./start.sh
# 1. Descarga Whisper (~2-3 min)
# 2. Descarga pyannote (~1-2 min)
# Total: ~3-5 minutos
```

**Cache location:**
```
~/.cache/huggingface/hub/
├── models--pyannote--speaker-diarization-3.1/
└── models--pyannote--segmentation-3.0/
```

**Siguientes ejecuciones:**
- Uso instantáneo ✅
- Sin descargas

---

## 🔄 Workflow de Uso

### Modo Simple (Solo Whisper)

```python
# No requiere HF_TOKEN
model = whisper.load_model("medium")
result = model.transcribe(audio_path)
```

**Requisitos:**
- ✅ Whisper model en cache
- ❌ No necesita HF_TOKEN
- ❌ No necesita internet (post-descarga)

### Modo Diarization (Whisper + Pyannote)

```python
# Requiere HF_TOKEN
pipeline = Pipeline.from_pretrained(
    "pyannote/speaker-diarization-3.1",
    use_auth_token=settings.HF_TOKEN
)
```

**Requisitos:**
- ✅ Whisper model en cache
- ✅ Pyannote models en cache
- ✅ HF_TOKEN en .env
- ✅ TOC aceptados en HuggingFace
- ❌ No necesita internet (post-descarga)

---

## 💾 Espacio en Disco

| Componente | Tamaño |
|-----------|--------|
| Whisper (medium) | 1.5 GB |
| Pyannote models | 2 GB |
| Dependencies | 500 MB |
| **Total** | **~4 GB** |

**Recomendación:** Mínimo 10 GB libres en disco.

---

## ⚡ Optimización

### Development

```bash
# .env para dev (más rápido)
WHISPER_MODEL=base      # 150 MB, rápido
HF_TOKEN=hf_xxxxx       # Solo si pruebas diarization
```

### Production

```bash
# .env para prod (mejor calidad)
WHISPER_MODEL=medium    # 1.5 GB, precisión 90-95%
HF_TOKEN=hf_xxxxx       # Necesario para conversaciones
```

### Testing

```bash
# .env para testing (mínimo recursos)
WHISPER_MODEL=tiny      # 75 MB, muy rápido
# HF_TOKEN no necesario si solo pruebas simple mode
```

---

## 🐛 Troubleshooting

### Error: "Model not found"

**Causa:** Primera descarga, modelo no en cache.

**Solución:** Esperar a que termine la descarga (1-5 min).

### Error: "Unauthorized" (Pyannote)

**Causa:** HF_TOKEN inválido o TOC no aceptados.

**Solución:**
1. Verificar token en .env
2. Aceptar TOC en links arriba
3. Reiniciar backend

### Error: "No space left on device"

**Causa:** Disco lleno.

**Solución:**
1. Liberar espacio (mínimo 5 GB)
2. Borrar cache si necesario:
   ```bash
   rm -rf ~/.cache/whisper/
   rm -rf ~/.cache/huggingface/
   ```
3. Reiniciar backend (descargará de nuevo)

---

## 📊 Comparación

| Aspecto | Whisper | Hugging Face |
|---------|---------|--------------|
| Función | Audio → Texto | Identificar speakers |
| Token | ❌ No requiere | ✅ Requiere (gratis) |
| Descarga | Auto, 1ra vez | Auto, 1ra vez |
| Cache | ~/.cache/whisper/ | ~/.cache/huggingface/ |
| Offline | ✅ Sí | ✅ Sí (post-download) |
| Uso | Siempre activo | Solo modo diarization |

---

## 🚀 Inicio Rápido

### Primera Vez

1. Instalar dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Configurar .env:
   ```bash
   WHISPER_MODEL=medium
   HF_TOKEN=hf_xxxxx  # Obtener en huggingface.co
   ```

3. Aceptar TOC en Hugging Face (links arriba)

4. Iniciar backend:
   ```bash
   ./start.sh
   # Esperar descargas (~5 min primera vez)
   ```

### Siguientes Veces

```bash
./start.sh
# Inicio instantáneo ✅
```

---

**Referencias:**
- Whisper: https://github.com/openai/whisper
- Pyannote: https://github.com/pyannote/pyannote-audio
- Hugging Face: https://huggingface.co
