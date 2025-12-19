# Arquitectura del Sistema

## 1. Base de Datos (Supabase / PostgreSQL)

El núcleo del sistema es una base de datos relacional fuertemente tipada con políticas de seguridad a nivel de fila (RLS).

### Esquema de Datos

#### Multi-Tenancy
- **empresas**: Entidad raíz.
- **sucursales**: Pertenecen a una empresa (`empresa_id`).
- **usuarios**: Vinculados a `auth.users` de Supabase, con `empresa_id` y `sucursal_id`.

#### RBAC (Role-Based Access Control)
- **roles**: Definición de roles (super_admin, admin, gerente, usuario).
- **permisos**: Capacidades atómicas (ej: `ver_reportes`).
- **usuario_permiso**: Asignación directa de permisos a usuarios.
- **invitaciones**: Sistema para invitar usuarios pre-asignando rol y empresa.

#### Sistema de Módulos (Marketplace)
- **modulos**: Catálogo global definido por Super Admin.
- **empresa_modulos**: Activación a nivel empresa.
- **sucursal_modulos**: Activación granular por sucursal + `precio_personalizado`.
- **usuario_modulos**: Activación granular por usuario + `precio_personalizado`.

### Seguridad (RLS)

Todas las tablas tienen RLS habilitado. Las políticas siguen este patrón:

1.  **Super Admin**: Acceso total (`public.es_super_admin()`).
2.  **Aislamiento**: Los usuarios solo ven registros donde `empresa_id` coincide con el suyo (`public.mi_empresa_id()`).
3.  **Jerarquía**:
    - `admin`: Puede gestionar todo dentro de su `empresa_id`.
    - `gerente`: (Futuro) Podrá gestionar su `sucursal_id`.

## 2. Lógica de Negocio (Flutter)

### Servicios

- **UserContext**: Singleton que mantiene el estado de la sesión, perfil del usuario, empresa y sucursal actual.
- **ModuleService**: Maneja la lógica de activación de módulos.
    - **Resolución de Activación**: `obtenerModulosActivos()` verifica en orden:
        1.  ¿Está activo para la Empresa? -> SÍ.
        2.  ¿Está activo para la Sucursal actual? -> SÍ.
        3.  ¿Está activo para el Usuario actual? -> SÍ.
- **CompanyService**: Gestión de sucursales y empleados.
- **SuperAdminService**: Funciones exclusivas de gestión global.

### UI / UX

- **ModuleGuard**: Widget que envuelve funcionalidades. Consulta `ModuleService` y decide si renderizar el `child` o un `fallback`.
- **MarketplaceScreen**: Interfaz para activar/desactivar módulos.
    - Detecta si el usuario es Super Admin o Admin de Empresa.
    - Permite configuración granular (Sucursal/Usuario) con precios personalizados si el módulo no está activo a nivel empresa.

## 3. Flujo de Precios y Cobranza (Futuro)

Actualmente, el sistema soporta la *definición* de precios:
- Precio base en tabla `modulos`.
- Precio personalizado en `sucursal_modulos` y `usuario_modulos`.

El cálculo de facturación mensual sumaría:
- (Módulos activos empresa * Precio base)
- + Sumatoria(Precios personalizados de sucursales)
- + Sumatoria(Precios personalizados de usuarios)
