# 🗄️ Database

Documentación de esquemas, migraciones y configuración de base de datos (Supabase).

---

## 📄 Documentos en esta sección

### [Schema SQL](./schema.sql)
Schema maestro de la base de datos con todas las tablas, relaciones, índices y políticas RLS.

---

## 📁 Subdirectorios

### [Migrations](./migrations/)
Archivos SQL de migraciones ordenadas cronológicamente. Cada migration incluye instrucciones de ejecución.

### [Guides](./guides/)
Guías específicas para configuración de base de datos:
- [Storage Setup](./guides/storage-setup.md) - Configuración de Supabase Storage
- [Theming SQL](./guides/theming-sql.md) - Ejecutar SQL para sistema de theming

---

## 🗃️ Tablas Principales

### Core
- `usuarios` - Usuarios del sistema
- `empresas` - Empresas (tenants)
- `modulos` - Módulos disponibles
- `empresas_modulos` - Relación empresa-módulos

### Business Logic
- `clientes` - Clientes de cada empresa
- `sucursales` - Sucursales de clientes
- `reclamos` - Reclamos/tickets
- `interacciones` - Historial de interacciones

### Customization
- `empresa_branding` - Theming multi-tenant
- `permisos_granulares` - Permisos por módulo

---

## 🔐 Row Level Security (RLS)

Todas las tablas implementan RLS para:
- ✅ Multi-tenancy (aislamiento entre empresas)
- ✅ Permisos por rol (admin, staff, user)
- ✅ Seguridad a nivel de fila

---

## 🚀 Migrations

### Ejecutar Nueva Migration

**Opción A: Supabase CLI** (recomendado):
```bash
supabase db push
```

**Opción B: Dashboard Supabase**:
1. Ir a SQL Editor
2. Copiar contenido de migration
3. Ejecutar

### Orden de Migrations

Las migrations están numeradas y deben ejecutarse en orden:
```
001_initial_schema.sql
002_add_theming_basic.sql
003_expand_theming.sql
...
```

---

## 📊 Diagrama ER (Simplificado)

```
empresas
  ├─→ usuarios (many)
  ├─→ empresa_branding (one)
  ├─→ empresas_modulos (many)
  └─→ clientes (many)
        ├─→ sucursales (many)
        └─→ reclamos (many)
              └─→ interacciones (many)
```

---

## 🔗 Enlaces Relacionados

- [Architecture](../02-architecture/README.md)
- [Theming Technical Guide](../03-guides/theming-technical.md)
- [Getting Started](../01-getting-started/README.md)
