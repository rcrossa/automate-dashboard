#!/bin/bash

# Start Backend Python Server
# Este script asegura que usamos el Python del venv, no pyenv

cd /Users/robertorossa/Desktop/Desarrollo/flutter/backend_python

# Usar el Python directo del venv (evita problemas con pyenv)
./venv/bin/python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
