# Guía de Instalación: Base de Datos

## 📋 Para Base de Datos VACÍA (Nuevo Proyecto)

Si estás empezando desde cero con una base de datos Supabase vacía:

### **Ejecutar un solo archivo:**
```
00_single_tenant_schema.sql
```

Este archivo crea:
- ✅ Empresa única (ID=1)
- ✅ Sucursal principal (Casa Matriz)
- ✅ Roles y capacidades
- ✅ Catálogo de módulos
- ✅ Tablas de usuarios, clientes, reclamos, interacciones
- ✅ RLS policies simplificadas
- ✅ Triggers y funciones
-✅ Datos semilla básicos

**Pasos:**
1. Abrir Supabase Dashboard
2. Ir a SQL Editor
3. Copiar contenido de `00_single_tenant_schema.sql`
4. Hacer clic en `Run`
5. ✅ ¡Listo!

**Verificación:**
```sql
SELECT COUNT(*) FROM empresas;  -- Debe retornar 1
SELECT COUNT(*) FROM modulos;   -- Debe retornar 9
SELECT COUNT(*) FROM sucursales; -- Debe retornar 1
```

---

## 🔄 Para Migrar desde Multi-Tenant Existente

Si ya tienes una base de datos multi-tenant y quieres convertirla:

### **Ejecutar en orden:**
1. `02_single_tenant_migration.sql` - Consolida datos a 1 empresa
2. `03_simplify_rls_policies.sql` - Simplifica policies
3. `04_seed_single_company.sql` - Datos semilla (opcional)

**⚠️ IMPORTANTE:** Crear backup antes de migrar

Ver guía completa: `README_MIGRATION.md`

---

## 🎯 Qué incluye el Schema

### Tablas Principales
- `empresas` - Empresa única (ID=1)
- `empresa_branding` - Theming/personalización
- `sucursales` - Múltiples ubicaciones
- `usuarios` - Staff y clientes
- `clientes` - Base de clientes CRM
- `reclamos` - Sistema de tickets/claims
- `interacciones` - Historial CRM
- `modulos` - Catálogo de funcionalidades
- `sucursal_modulos` - Activación por sucursal

### Módulos Disponibles
- Dashboard Principal (gratis)
- Gestión de Clientes (gratis)
- Sistema de Reclamos (gratis)
- CRM de Interacciones (gratis)
- Gestión de Personal (gratis)
- Gestión de Sucursales (gratis)
- Reportes Automáticos ($10/mes)
- Inventario ($20/mes - próximamente)
- Speech-to-Text ($30/mes)

### Características
- ✅ RLS habilitado (seguridad a nivel fila)
- ✅ Políticas simplificadas single-tenant
- ✅ Triggers automáticos para usuarios nuevos
- ✅ Índices optimizados
- ✅ Funciones de búsqueda

---

## 📞 Solución de Problemas

### Error: "permission denied for schema public"
**Solución**: Ejecutar como usuario con permisos de creación de tablas

### Error: "relation already exists"
**Solución**: Ya tienes tablas creadas, usa migración en vez de schema nuevo

### Error: "function es_admin() does not exist"  
**Solución**: Ejecutar nuevamente `00_single_tenant_schema.sql` completo

---

## ✅ Próximos Pasos

Después de ejecutar el schema:
1. Configurar `.env` en Flutter app con credenciales de Supabase
2. Ejecutar `flutter pub get` en `/app`
3. Correr la aplicación

---

**Creado:** 2025-12-19  
**Versión:** 1.0
