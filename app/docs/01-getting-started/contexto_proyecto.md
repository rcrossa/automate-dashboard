# Contexto del Proyecto (Memory Bank)

Este documento sirve como "memoria a largo plazo" del proyecto `msasb_app`. Contiene la información crítica sobre arquitectura, reglas de negocio y decisiones clave que no deben olvidarse.

## 1. Identidad del Proyecto
- **Nombre del Paquete**: `msasb_app`
- **Nombre Interno/Repo**: `My_Smart_App_Sistema_Base`
- **Repositorio**: `https://github.com/rcrossa/My_Smart_App_Sistema_Base`
- **Descripción**: Sistema base para gestión de empresas, sucursales y empleados con arquitectura multi-tenant.

## 2. Arquitectura Técnica
- **Frontend**: Flutter.
- **Backend**: Supabase (PostgreSQL + Auth + Edge Functions).
- **Gestión de Estado**: Riverpod (Providers & Consumers).
    - `userStateProvider`: Mantiene la sesión global (Usuario, Empresa, Sucursal).
    - `activeModulesProvider`: Cachea los módulos activos.
- **Patrón**: Layered Architecture (Screens -> Widgets -> Providers -> Services -> Models).
- **Internacionalización**: `flutter_localizations` (.arb files). **Prohibidos los textos hardcoded**.

## 3. Reglas de Negocio Clave

### Roles y Jerarquía
1.  **Super Admin**: Acceso total al sistema y gestión de empresas (Backoffice Global).
2.  **Admin (Empresa)**: Gestiona su propia empresa, sucursales y empleados.
3.  **Gerente (Sucursal)**: Gestiona una sucursal específica.
4.  **Usuario/Staff**: Empleado base con acceso limitado (ej: Portal Staff).

### Sistema de Módulos
- **Granularidad**: Los módulos se pueden activar a nivel Empresa, Sucursal o Usuario.
- **ModuleGuard**: Widget que protege la UI basándose en los módulos activos.
- **Optimización**: La lista de módulos activos se descarga **una sola vez** al iniciar sesión (`ModuleProvider`).

### Multi-tenancy
- **Seguridad**: Se usa RLS (Row Level Security) en Supabase.
- **Aislamiento**: Un usuario de la Empresa A **nunca** debe ver datos de la Empresa B.

## 4. Preferencias del Usuario
- **Documentación**:
    - Usar ✅ para tareas completadas en listas (no `[x]`).
    - Mantener `docs/pendientes.md` actualizado con deuda técnica.
- **UI/UX**:
    - Estilo "Premium" y moderno.
    - Evitar placeholders, usar datos reales o simulados de alta calidad.
- **Git**:
    - Commits descriptivos.
    - Ramas `main` protegida (idealmente).

## 5. Estado Actual (Resumen)
- **Login/Registro**: Funcional con `username`.
- **Gestión de Empresas**: Funcional (CRUD Sucursales, Empleados).
- **Dashboard**: Diferenciado por rol (Admin vs Gerente vs Usuario).
- **Deuda Técnica**: Ver `docs/pendientes.md`.
