# Guía: Generar e Instalar APK en Android

**Última actualización**: 13 de Diciembre 2025

Esta guía documenta cómo generar APKs de Flutter para Android y los diferentes métodos de instalación.

---

## 📦 Generar APK

### Opción 1: APK Debug (Para Testing Rápido)

```bash
flutter build apk --debug
```

**Características**:
- ⚡ Compilación rápida (~2-3 minutos)
- 📦 Tamaño grande (~100 MB)
- 🐛 Incluye símbolos de debug
- ✅ Ideal para testing interno

**Ubicación del APK**:
```
build/app/outputs/flutter-apk/app-debug.apk
```

---

### Opción 2: APK Release (Para Distribución)

```bash
flutter build apk --release
```

**Características**:
- 🚀 Optimizado y minificado
- 📦 Tamaño pequeño (~15-25 MB)
- ⏱️ Compilación más lenta (~5-10 minutos)
- ✅ Mejor performance
- ⚠️ Requiere firma digital

**Ubicación del APK**:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

### Opción 3: APK Split por ABI (Recomendado para Google Play)

```bash
flutter build apk --split-per-abi
```

**Genera 3 APKs separados**:
- `app-armeabi-v7a-release.apk` (ARM 32-bit - ~10 MB)
- `app-arm64-v8a-release.apk` (ARM 64-bit - ~12 MB)
- `app-x86_64-release.apk` (Intel 64-bit - ~15 MB)

**Ventaja**: Usuarios descargan solo el APK de su arquitectura

---

## 🔧 Troubleshooting

### Error: NDK Version Mismatch

**Síntoma**:
```
[CXX1101] NDK at /path/to/ndk/27.0.12077973 did not have a source.properties file
```

**Solución**:
Mantener la configuración por defecto en `android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = flutter.ndkVersion  // ✅ Correcto
    // ndkVersion = "27.0.12077973"  // ❌ Evitar hardcodear
}
```

**Warnings como este son normales y no afectan la funcionalidad**:
```
Your project is configured with Android NDK 26.3.11579264, 
but the following plugin(s) depend on Android NDK 27.0.12077973
```

---

### Error: Signing Config (Solo Release)

**Síntoma**:
```
A failure occurred while executing com.android.build.gradle.internal.tasks.SigningConfigWriterTask
```

**Solución**: Configurar firma digital (una sola vez)

**1. Crear keystore**:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**2. Crear archivo de configuración**:
```bash
echo "storePassword=TU_PASSWORD
keyPassword=TU_PASSWORD
keyAlias=upload
storeFile=/Users/TU_USUARIO/upload-keystore.jks" > android/key.properties
```

**3. Agregar a `.gitignore`**:
```bash
echo "android/key.properties" >> .gitignore
echo "*.jks" >> .gitignore
```

---

## 📱 Métodos de Instalación

### Método 1: Google Drive (Más Confiable) ⭐

**Pasos**:
1. Sube el APK a Google Drive:
   ```
   build/app/outputs/flutter-apk/app-debug.apk
   ```

2. En tu dispositivo Android:
   - Abre Google Drive
   - Encuentra el archivo APK
   - Toca para descargar
   - Toca el archivo descargado

3. Si es la primera vez, Android pedirá:
   - "Permitir instalar apps de esta fuente"
   - Activa el permiso para Google Drive
   - Vuelve atrás e instala

**Ventajas**:
- ✅ Funciona siempre
- ✅ No requiere cables ni configuración
- ✅ Fácil de compartir con otros

---

### Método 2: Cable USB + ADB

**Requisitos**:
- Android SDK Platform Tools instalado
- Cable USB
- Depuración USB habilitada

**Pasos**:

**A. Instalar ADB** (si no lo tienes):
```bash
brew install --cask android-platform-tools
```

**B. Habilitar Depuración USB en Android**:
1. Ve a **Ajustes** → **Acerca del teléfono**
2. Toca 7 veces en "Número de compilación"
3. Ve a **Ajustes** → **Sistema** → **Opciones de desarrollador**
4. Activa **Depuración USB**

**C. Conectar y Autorizar**:
1. Conecta el cable USB
2. En el teléfono: "¿Permitir depuración USB?"
3. Marca "Permitir siempre" y acepta

**D. Verificar conexión**:
```bash
adb devices
```

Debería mostrar:
```
List of devices attached
XXXXXXXX        device
```

**E. Instalar APK**:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

O usar Flutter directamente:
```bash
flutter install
```

**Ventajas**:
- ✅ Instalación directa
- ✅ Útil para desarrollo constante

**Desventajas**:
- ⚠️ Requiere configuración inicial
- ⚠️ Puede fallar si hay problemas de drivers

---

### Método 3: Email

**Pasos**:
1. Envíate el APK por email como adjunto
2. Abre el email en tu Android
3. Descarga el adjunto
4. Instala desde "Descargas"

**Ventajas**:
- ✅ Simple y rápido
- ✅ No requiere apps adicionales

**Desventajas**:
- ⚠️ Algunos servicios limitan archivos grandes (>25 MB)

---

### Método 4: Transferencia Directa (Finder en Mac)

**Pasos**:
1. Conecta el Android por USB
2. En Mac, abre **Finder**
3. Selecciona tu dispositivo en la barra lateral
4. Arrastra el APK a la carpeta "Descargas" del dispositivo
5. En Android, abre "Archivos" → "Descargas"
6. Toca el APK para instalar

**Ventajas**:
- ✅ Rápido si tienes cable
- ✅ No requiere internet

---

## 🔄 Proceso para Actualizar la App

### Si solo cambió código Dart:

```bash
flutter build apk --debug
# APK en: build/app/outputs/flutter-apk/app-debug.apk
# Desinstala la versión anterior del teléfono
# Instala la nueva versión (por el método que prefieras)
```

### Si cambió la versión:

**1. Actualizar `pubspec.yaml`**:
```yaml
version: 1.0.1+2  # versión+buildNumber
```

**2. Generar APK**:
```bash
flutter clean
flutter build apk --release
```

### Si agregaste/actualizaste dependencias:

```bash
flutter pub get
flutter clean
flutter build apk --debug
```

---

## 📋 Checklist de Compilación

**Antes de compilar**:
- [ ] Código commitado en git
- [ ] Tests pasando (`flutter test`)
- [ ] Sin errores de análisis (`flutter analyze`)
- [ ] Versión actualizada en `pubspec.yaml` (si aplica)

**Para Debug**:
```bash
flutter build apk --debug
```

**Para Release** (distribución):
```bash
flutter build apk --release
```

**Verificar APK generado**:
```bash
ls -lh build/app/outputs/flutter-apk/
```

---

## ⚠️ Notas Importantes

### Warnings Comunes (Ignorables)

**1. NDK Version**:
```
Your project is configured with Android NDK X, but plugins depend on Y
```
👉 **Ignorar**: Los NDK son backward compatible

**2. Deprecation Warnings**:
```
Support for Android x86 targets will be removed...
```
👉 **Ignorar**: Solo para arquitecturas muy antiguas

**3. Source/Target Obsolete**:
```
warning: [options] source value 8 is obsolete
```
👉 **Ignorar**: Java 8 sigue siendo compatible

---

### Permisos en Android

La app puede pedir estos permisos al instalar:
- 📷 **Cámara**: Para photo_picker
- 📁 **Archivos**: Para file_picker
- 🌐 **Internet**: Para Supabase
- 📍 **Ubicación**: Si usas geolocalización

Todos son normales para esta aplicación.

---

## 🚀 Distribución a Usuarios

### Opción A: Testing Interno (Google Drive)
1. Genera APK release
2. Sube a Drive compartido
3. Comparte link con testers
4. Dales instrucciones de instalación

### Opción B: Google Play Store (Beta Cerrada)
1. Genera AAB (no APK):
   ```bash
   flutter build appbundle --release
   ```
2. Sube a Google Play Console
3. Crea "Prueba cerrada"
4. Invita testers por email

### Opción C: Direct Download (Tu Servidor)
1. Sube APK a servidor web
2. Comparte link directo
3. Usuarios descargan e instalan

---

## 📞 Soporte

**Errores de compilación**: Revisar sección Troubleshooting

**No detecta dispositivo**: Usar método Google Drive

**APK no instala**: Verificar que sea la arquitectura correcta

**App crashea**: Revisar logs con `flutter logs` o `adb logcat`

---

**Última actualización**: 13 Diciembre 2025  
**Versión de Flutter**: 3.32.2  
**Versión mínima Android**: 5.0 (API 21)
