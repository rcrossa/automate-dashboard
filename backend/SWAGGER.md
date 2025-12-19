# Swagger/OpenAPI Documentation

## 🎯 Acceso a la Documentación

El backend Python incluye documentación interactiva automática:

### Swagger UI (Recomendado)
```
http://localhost:8000/docs
```
**Características:**
- Interfaz interactiva para probar endpoints
- Ejemplos de requests/responses
- Validación en tiempo real
- "Try it out" para ejecutar requests

### ReDoc (Alternativo)
```
http://localhost:8000/redoc
```
**Características:**
- Documentación más limpia y legible
- Mejor para compartir con clientes
- Navegación por tags

### OpenAPI JSON
```
http://localhost:8000/openapi.json
```
Esquema programático para generadores de código.

---

## 📋 Endpoints Disponibles

### Health Check
```
GET /health
```
Verifica estado del servidor, modelo Whisper, y si diarization está habilitado.

### Transcripción
```
POST /api/v1/transcribe?mode=simple|diarization
```

**Headers:**
```
X-API-Key: your-api-key-here
Content-Type: multipart/form-data
```

**Form Data:**
- `file`: Audio file (m4a, mp3, wav, etc.)
- `user_id`: User identifier
- `language`: (opcional) es, en, etc.

**Query Params:**
- `mode`: "simple" (rápido) o "diarization" (con speakers)

---

## 🧪 Probar desde Swagger UI

1. Abrir http://localhost:8000/docs
2. Click en endpoint `/api/v1/transcribe`
3. Click "Try it out"
4. Llenar parámetros:
   - `X-API-Key`: tu API key
   - `file`: Seleccionar archivo de audio
   - `user_id`: test-user
   - `mode`: simple o diarization
5. Click "Execute"
6. Ver response abajo con JSON completo

---

## 📊 Ejemplos de Response

### Modo Simple
```json
{
  "transcription": "Hola, necesito ayuda con mi pedido.",
  "language": "es",
  "confidence": 0.95,
  "duration_seconds": 3.2,
  "mode": "simple",
  "created_at": "2025-12-15T20:00:00Z"
}
```

### Modo Diarization
```json
{
  "transcription": "Hola, ¿en qué puedo ayudarle? Necesito ayuda.",
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
      "text": "Necesito ayuda.",
      "confidence": 0.91
    }
  ],
  "created_at": "2025-12-15T20:00:00Z"
}
```

---

## 🔍 Features de Swagger

- ✅ Auto-generado desde código Python
- ✅ Siempre sincronizado con implementación
- ✅ Ejemplos de requests/responses
- ✅ Validación de tipos
- ✅ Descripciones detalladas
- ✅ Tags para organización
- ✅ Schemas Pydantic

---

## 🚀 Production

En producción, Swagger estará disponible en:
```
https://your-app.railway.app/docs
https://your-app.railway.app/redoc
```

**Seguridad:** Considera deshabilitar `/docs` en producción si es sensible:
```python
app = FastAPI(
    docs_url=None if settings.ENVIRONMENT == "production" else "/docs"
)
```

---

**Última actualización:** 2025-12-15
