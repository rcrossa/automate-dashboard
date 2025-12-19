# Sistema de Gestión Multi-Tenant con Flutter y Supabase

Este proyecto es una aplicación Flutter diseñada como una plataforma SaaS Multi-Tenant, permitiendo la gestión de múltiples empresas, sucursales y usuarios con un sistema de permisos y módulos granular.

## Características Principales

### 1. Multi-Tenancy Real
- **Aislamiento de Datos**: Cada empresa accede solo a sus propios datos (RLS en base de datos).
- **Jerarquía**: Empresa -> Sucursales -> Usuarios.

### 2. Sistema de Roles y Permisos (RBAC)
- **Super Admin**: Gestión global de todas las empresas y el catálogo de módulos.
- **Admin**: Gestión total de su propia empresa.
- **Gerente**: Gestión de su sucursal asignada.
- **Usuario**: Acceso básico a funcionalidades operativas.
- **Permisos Granulares**: Capacidades específicas (ver_reportes, editar_usuarios, etc.) asignables por usuario.

### 3. Marketplace de Módulos
- **Arquitectura Modular**: Las funcionalidades (Reclamos, CRM, Dashboard, etc.) son módulos activables.
- **Activación Granular**:
    - **Nivel Empresa**: Activa el módulo para toda la organización.
    - **Nivel Sucursal**: Activa el módulo solo para sucursales específicas.
    - **Nivel Usuario**: Activa el módulo solo para empleados específicos.
- **Precios Personalizados**: El Super Admin puede definir precios específicos por activación granular.

### 4. Dashboard Modular
- La aplicación actúa como un contenedor.
- El módulo `dashboard` controla la visualización de los widgets principales.
- Si el módulo no está activo, el usuario ve una pantalla de bloqueo informativa.

### 5. Diseño Responsive ✨ NUEVO
- **Mobile First**: Diseño optimizado para dispositivos móviles
- **Breakpoints Material Design**:
  - Mobile: < 600px
  - Tablet: 600px - 1200px  
  - Desktop: ≥ 1200px
- **Helper Centralizado**: `ResponsiveHelper` para layouts adaptivos
- **Cobertura**: 9 pantallas + 3 dialogs responsive
- **Documentación**: Ver [Responsive Design Guide](docs/responsive_design_guide.md)

### 6. Testing Automatizado
- **Tests Unitarios**: 41 tests (incluye 7 para ResponsiveHelper)
- **Integration Tests**: Configurados para flujos críticos (auth, navegación)
- **Documentación**: Ver [Integration Tests Guide](docs/integration_tests_guide.md)

## Tecnologías

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL + Auth + Realtime)
- **State Management**: Riverpod
- **Seguridad**: Row Level Security (RLS) en PostgreSQL
- **Testing**: flutter_test, integration_test
- **Arquitectura**: Clean Architecture con capas domain/data/presentation

## Configuración del Proyecto

### Requisitos Previos
- Flutter SDK instalado
- Cuenta en Supabase

### Instalación

1.  **Clonar el repositorio**:
    ```bash
    git clone <url-del-repo>
    cd mi_primera_app
    ```

2.  **Configurar Variables de Entorno**:
    Crea un archivo `.env` en la raíz del proyecto:
    ```env
    SUPABASE_URL=tu_url_de_supabase
    SUPABASE_ANON_KEY=tu_anon_key_de_supabase
    ```

3.  **Configurar Base de Datos**:
    Ejecuta el script SQL maestro en el Editor SQL de Supabase:
    - `docs/database/01_schema_completo_multitenant.sql`

    (Opcional) Para datos de prueba:
    - `docs/database/02_datos_semilla.sql`

4.  **Instalar Dependencias**:
    ```bash
    flutter pub get
    ```

5.  **Ejecutar la Aplicación**:
    ```bash
    flutter run
    ```

## Estructura del Proyecto

```
lib/
├── domain/           # Entidades y lógica de negocio
├── data/             # Repositorios e implementaciones
├── presentation/     # UI (Screens, Widgets, Providers)
├── utils/            # Helpers y utilidades (ResponsiveHelper)
├── l10n/             # Internacionalización
└── main.dart         # Punto de entrada

docs/
├── contexto_proyecto.md          # Contexto general del proyecto
├── pendientes.md                 # Tareas y mejoras pendientes
├── responsive_design_guide.md    # Guía técnica de diseño responsive
├── integration_tests_guide.md    # Guía de integration tests
└── theming_guide.md              # Guía de personalización de temas

test/
├── domain/           # Tests de entidades
├── presentation/     # Tests de widgets y screens
├── utils/            # Tests de helpers (ResponsiveHelper)
└── helpers/          # Mocks y utilidades de testing

integration_test/
├── auth_flow_test.dart        # Tests de autenticación
├── navigation_test.dart       # Tests de navegación
└── helpers/                   # Helpers para integration tests
```

## Documentación

### Para Desarrolladores
- **[Contexto del Proyecto](docs/contexto_proyecto.md)**: Arquitectura y decisiones técnicas
- **[Responsive Design Guide](docs/responsive_design_guide.md)**: Guía completa de diseño responsive
- **[Integration Tests Guide](docs/integration_tests_guide.md)**: Cómo ejecutar y crear integration tests
- **[Theming Guide](docs/theming_guide.md)**: Personalización de colores y temas

### Gestión del Proyecto
- **[Tareas Pendientes](docs/pendientes.md)**: Lista de mejoras y próximos pasos

## Testing

### Ejecutar Tests Unitarios
```bash
flutter test
```

**Resultado esperado**: 41/41 tests pasando ✅

### Ejecutar Integration Tests
```bash
# Requiere dispositivo/emulador (no funciona en web)
flutter test integration_test/ -d macos

# O en dispositivo específico
flutter devices  # Ver dispositivos disponibles
flutter test integration_test/ -d <device_id>
```

### Análisis Estático
```bash
flutter analyze
```

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

[Definir licencia]

## Contacto

[Información de contacto]
