# Sistema de Módulos

El sistema de módulos permite activar o desactivar funcionalidades de la aplicación de forma dinámica para cada Empresa, Sucursal o Usuario.

## Arquitectura

### 1. Base de Datos
Existen 3 tablas de relación para controlar el acceso:
- `empresa_modulos`: Módulos activos para toda la empresa.
- `sucursal_modulos`: Módulos activos para una sucursal específica (Granularidad).
- `usuario_modulos`: Módulos activos para un usuario específico (Granularidad).

### 2. Servicio (`ModuleService`)
Encargado de consultar Supabase.
- `obtenerModulosActivos()`: Consolida los permisos de los 3 niveles y devuelve una lista de códigos de módulos activos (ej: `['dashboard', 'reclamos']`).

### 3. Estado (`ModuleProvider`)
Usamos Riverpod para cachear la lista de módulos activos y evitar consultas excesivas a la base de datos.
- **Provider**: `activeModulesProvider`
- **Ciclo de vida**: Se carga al iniciar la sesión (o cambiar de empresa/sucursal) y se mantiene en memoria (`keepAlive: true`).

### 4. UI (`ModuleGuard`)
Widget que protege partes de la interfaz.
- **Uso**: Envuelve cualquier widget que requiera un módulo activo.
- **Funcionamiento**: Escucha `activeModulesProvider`. Si el código del módulo está en la lista, muestra el `child`. Si no, muestra `fallback` o nada.

## Ejemplo de Uso

```dart
ModuleGuard(
  moduleCode: 'dashboard',
  fallback: Text('No tienes acceso al dashboard'),
  child: DashboardScreen(),
)
```

## Flujo de Optimización
Antes, `ModuleGuard` consultaba la DB en cada `build`. Ahora:
1. `UserSession` cambia (Login).
2. `activeModulesProvider` detecta el cambio y descarga la lista de módulos (1 sola consulta).
3. `ModuleGuard` lee la lista de memoria instantáneamente.

---

## Módulos Disponibles

### Módulos Actuales

| Código | Nombre | Descripción | Guía |
|--------|--------|-------------|------|
| `dashboard` | Dashboard | Panel principal de administración | - |
| `reclamos` | Reclamos | Gestión de claims/reclamaciones | - |
| `clientes` | Clientes | Gestión de clientes | - |
| `personal` | Personal | Gestión de empleados | - |
| `sucursales` | Sucursales | Gestión de sucursales | - |
| `speech_to_text` | Speech-to-Text | Grabación y transcripción de audio | [Guía](../03-guides/speech-to-text.md) |

### Uso del Módulo Speech-to-Text

```dart
ModuleGuard(
  moduleCode: 'speech_to_text',
  fallback: SizedBox.shrink(), // Ocultar si no está activo
  child: RecordAudioButton(
    onRecordingComplete: (audioPath) {
      // Procesar audio
    },
  ),
)
```

Para activar el módulo en una empresa, ejecutar:

```sql
-- Ver documentacion_unificada/modulos/activate_speech_to_text.sql
INSERT INTO empresa_modulos (empresa_id, modulo_codigo)
VALUES (1, 'speech_to_text');
```

