# Arquitectura del Proyecto Flutter

## Visión General
Este proyecto utiliza una arquitectura modular basada en **Clean Architecture** simplificada, con **Riverpod** para la gestión de estado y **Supabase** como backend (BaaS).

## Estructura de Directorios
```
lib/
├── core/               # Código base reutilizable
│   └── error/          # Definiciones de fallos y excepciones
├── l10n/               # Archivos de internacionalización (ARB)
├── models/             # Modelos de datos (DTOs)
├── providers/          # Riverpod Providers (Gestión de Estado)
├── screens/            # Pantallas de la aplicación (UI)
│   ├── admin/          # Pantallas de Administrador
│   ├── auth/           # Pantallas de Autenticación
│   ├── branch/         # Pantallas de Sucursal
│   ├── company/        # Pantallas de Empresa
│   └── user/           # Pantallas de Usuario Final
├── services/           # Lógica de negocio y llamadas a API
└── widgets/            # Widgets reutilizables globales
```

## Tecnologías Clave

### 1. Gestión de Estado: Riverpod
Utilizamos `flutter_riverpod` junto con `riverpod_annotation` para la generación de código.
- **Providers**: Se ubican en `lib/providers/`.
- **Uso**: `ref.watch(provider)` en widgets que extienden `ConsumerWidget`.

### 2. Backend: Supabase
- **Cliente Centralizado**: Accesible vía `supabaseClientProvider` (definido en `lib/presentation/providers/supabase_provider.dart`).
- **Autenticación**: Gestionada por Supabase Auth a través de `AuthRepository`.
- **Base de Datos**: PostgreSQL con Row Level Security (RLS) para multi-tenancy.
- **Patrón**: Todos los repository providers usan `ref.watch(supabaseClientProvider)` en lugar de acceso directo, siguiendo Dependency Inversion Principle.

### 3. Internacionalización (l10n)
- **Configuración**: `l10n.yaml`.
- **Archivos**: `lib/l10n/app_es.arb` (Español) y `lib/l10n/app_en.arb` (Inglés).
- **Uso**: `AppLocalizations.of(context)!.keyName`.

### 4. Manejo de Errores
- **Clases**: Definidas en `lib/core/error/failure.dart` (`ServerFailure`, `AuthFailure`, etc.).
- **Estrategia**: Los servicios capturan excepciones de bajo nivel (ej. `PostgrestException`) y lanzan objetos `Failure` estandarizados. La UI debe capturar estos `Failure` y mostrar mensajes amigables.

## Patrones de Diseño
- **Repository Pattern**: Abstrae la fuente de datos (Supabase) de la lógica de negocio mediante interfaces en `lib/domain/repositories/` e implementaciones en `lib/data/repositories/`.
- **Provider Pattern**: Gestión de estado global y de sesión mediante Riverpod (`UserState`, repository providers).
- **Dependency Injection**: Todos los repository providers usan `supabaseClientProvider` centralizado, facilitando testing y desacoplamiento.
- **Widget Composition**: UI dividida en widgets pequeños y reutilizables.

## Guía de Estilo
- **Nombres de Archivos**: `snake_case` (ej. `user_provider.dart`).
- **Clases**: `PascalCase` (ej. `UserProvider`).
- **Variables**: `camelCase` (ej. `userList`).
- **Imports**: Usar rutas relativas para archivos dentro del mismo módulo y absolutas (package:) para módulos externos o distantes.
