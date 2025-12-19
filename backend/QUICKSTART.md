# 🚀 Backend Python - Quick Start

## ✅ Solución al Error: ModuleNotFoundError

**Problema**: Ejecutar `uvicorn app.main:app` usa Python global de pyenv, no el venv.

**Solución**: SIEMPRE activar venv primero:

```bash
cd /Users/robertorossa/Desktop/Desarrollo/flutter/backend_python

# 1. Activar virtual environment
source venv/bin/activate

# 2. Instalar dependencias CORE (mínimas para arrancar)
pip install fastapi "uvicorn[standard]" pydantic pydantic-settings python-dotenv python-multipart

# 3. Iniciar servidor
uvicorn app.main:app --reload
```

## 📦 Instalación Completa (Opcional - con Whisper)

Si quieres funcionalidad completa de transcripción:

```bash
source venv/bin/activate

# Instalar TODAS las dependencias (puede tardar 10 min)
pip install -r requirements.txt
```

**Nota**: Whisper + PyTorch son ~2GB. Si solo quieres probar la API sin transcripción, no es necesario.

## ✅ Verificar que funciona

Después de `uvicorn app.main:app --reload`, deberías ver:

```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete.
```

**Test en navegador**: http://127.0.0.1:8000
**API Docs**: http://127.0.0.1:8000/docs

## 🔧 Script de inicio rápido

Crear `start.sh`:

```bash
#!/bin/bash
cd /Users/robertorossa/Desktop/Desarrollo/flutter/backend_python
source venv/bin/activate
uvicorn app.main:app --reload
```

```bash
chmod +x start.sh
./start.sh
```

## ⚠️ Recuerda SIEMPRE

1. ✅ `cd backend_python`
2. ✅ `source venv/bin/activate`  ← **CRÍTICO**
3. ✅ `uvicorn app.main:app --reload`

Si olvidas el paso 2, usarás pyenv global y fallará.
