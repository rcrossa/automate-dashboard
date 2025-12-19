# Guía de Migración: Multi-Tenant → Single-Tenant

## ⚠️ IMPORTANTE: LEER ANTES DE EJECUTAR

Esta migración es **irreversible** sin un backup. Asegúrate de tener un backup completo de tu base de datos antes de proceder.

---

## 📋 Pre-requisitos

1. ✅ Acceso administrativo a la base de datos Supabase
2. ✅ Backup completo de la base de datos
3. ✅ Ambiente de prueba para validar (recomendado)
4. ✅ Leer completamente esta guía

---

## 🔄 Proceso de Migración

### Paso 1: Crear Backup

**Opción A: Via Supabase Dashboard**
1. Ir a `Settings` → `Database` → `Backups`
2. Crear backup manual
3. Esperar confirmación

**Opción B: Via pg_dump (si tienes acceso directo)**
```bash
pg_dump -U postgres -h your-host -d your-database > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Paso 2: Ejecutar Scripts SQL

Los scripts deben ejecutarse en **orden estricto**:

#### 2.1 Script de Migración Principal
```sql
-- Archivo: 02_single_tenant_migration.sql
-- Ejecutar en: Supabase SQL Editor
```

**¿Qué hace?**
- Consolida todos los datos a una empresa única
- Elimina tablas de módulos: `modulos`, `empresa_modulos`, `sucursal_modulos`, `usuario_modulos`
- Elimina tabla `invitaciones`
- Elimina empresas adicionales (mantiene solo la primera)
- Convierte usuarios `super_admin` a `admin`
- Elimina funciones multi-tenant: `mi_empresa_id()`, `es_super_admin()`
- Actualiza trigger `handle_new_user()` para asignar automáticamente `empresa_id = 1`

**Pasos:**
1. Abre Supabase Dashboard → SQL Editor
2. Copia el contenido de `02_single_tenant_migration.sql`
3. Click en `Run`
4. Verifica que el resultado termine con "MIGRACIÓN COMPLETADA EXITOSAMENTE"
5. Lee el resumen mostrado (empresa única, total usuarios, etc.)

#### 2.2 Simplificar RLS Policies
```sql
-- Archivo: 03_simplify_rls_policies.sql
-- Ejecutar en: Supabase SQL Editor
```

**¿Qué hace?**
- Elimina todas las policies multi-tenant
- Crea policies simplificadas que permiten acceso a todos los usuarios autenticados
- Mantiene restricciones de rol (admin para ciertas operaciones)

**Pasos:**
1. Copia el contenido de `03_simplify_rls_policies.sql`
2. Click en `Run`
3. Verifica mensaje "RLS POLICIES SIMPLIFICADAS EXITOSAMENTE"

#### 2.3 Datos Semilla (Opcional)
```sql
-- Archivo: 04_seed_single_company.sql
-- Ejecutar en: Supabase SQL Editor
```

**¿Qué hace?**
- Crea empresa con nombre "Mi Empresa" (si no existe)
- Configura branding básico
- Crea sucursal "Casa Matriz"
- Inserta tipos de reclamo básicos (General, Técnico, Servicio, Facturación)
- Inserta tipos de interacción básicos (Llamada, Email, Reunión, WhatsApp, Visita)

**Pasos:**
1. Copia el contenido de `04_seed_single_company.sql`
2. Click en `Run`
3. Verifica mensaje "DATOS SEMILLA INSERTADOS EXITOSAMENTE"

### Paso 3: Verificar Migración

**Queries de verificación:**

```sql
-- 1. Verificar que solo existe 1 empresa
SELECT COUNT(*) FROM empresas;
-- Resultado esperado: 1

-- 2. Verificar empresa única
SELECT id, nombre, codigo FROM empresas;
-- Resultado esperado: 1 fila con id=1

-- 3. Verificar que no existen roles super_admin
SELECT nombre FROM roles WHERE nombre = 'super_admin';
-- Resultado esperado: 0 filas

-- 4. Verificar que no existe tabla modulos
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'modulos';
-- Resultado esperado: 0 filas

-- 5. Verificar que todos los usuarios tienen empresa_id = 1
SELECT DISTINCT empresa_id FROM usuarios;
-- Resultado esperado: solo "1"

-- 6. Verificar funciones eliminadas
SELECT routine_name FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name IN ('mi_empresa_id', 'es_super_admin');
-- Resultado esperado: 0 filas
```

---

## 🧪 Testing Post-Migración

### Test 1: Autenticación
1. Login con usuario existente
2. Verificar que carga correctamente
3. Verificar que puede ver dashboard

### Test 2: Creación de Usuario
1. Registrar nuevo usuario
2. Verificar que se asigna automáticamente `empresa_id = 1`
3. Verificar que tiene rol "usuario" por defecto

```sql
-- Verificar último usuario creado
SELECT id, email, empresa_id, tipo_perfil 
FROM usuarios 
ORDER BY creado_en DESC 
LIMIT 1;
```

### Test 3: CRUD Básico
1. Crear un reclamo
2. Crear un cliente
3. Crear una interacción
4. Verificar que se guardan correctamente

### Test 4: RLS Policies
1. Login como usuario normal
2. Verificar que puede ver todos los reclamos
3. Login como admin
4. Verificar que puede editar configuración

---

## 🚨 Troubleshooting

### Error: "empresa_id no puede ser NULL"
**Causa:** Algún insert no está asignando empresa_id.

**Solución:**
```sql
-- Actualizar registros sin empresa_id
UPDATE <tabla> SET empresa_id = 1 WHERE empresa_id IS NULL;
```

### Error: "función mi_empresa_id() no existe"
**Causa:** Código Flutter aún hace referencia a la función eliminada.

**Solución:** Esperar a Sprint 3 (refactorización Flutter) o revertir migración.

### Error: Policies bloqueando acceso
**Causa:** Policies no se actualizaron correctamente.

**Solución:**
```sql
-- Re-ejecutar
\i 03_simplify_rls_policies.sql
```

---

## 📊 Rollback (Reversión)

Si algo sale mal y tienes el backup:

**Via Supabase Dashboard:**
1. Settings → Database → Backups
2. Restaurar el backup creado en Paso 1

**Via pg_restore (si tienes acceso directo):**
```bash
psql -U postgres -h your-host -d your-database < backup_YYYYMMDD_HHMMSS.sql
```

---

## ✅ Checklist de Migración

- [ ] Backup creado y verificado
- [ ] Script `02_single_tenant_migration.sql` ejecutado exitosamente
- [ ] Script `03_simplify_rls_policies.sql` ejecutado exitosamente
- [ ] Script `04_seed_single_company.sql` ejecutado (opcional)
- [ ] Queries de verificación ejecutadas
- [ ] Tests post-migración pasando
- [ ] Documentado cualquier issue encontrado

---

## 🎯 Siguiente Fase

Una vez completada la migración de BD:

**Sprint 2:** Actualizar Backend Python
- Archivo: Ver `refactoring_plan.md` → Sprint 2

---

## 📞 Soporte

Si encuentras problemas durante la migración:
1. Revisa esta guía completamente
2. Verifica logs de Supabase
3. Consulta `troubleshooting` section
4. Si es crítico: restaura backup y documenta el error

---

**Creado:** 2025-12-19  
**Versión:** 1.0  
**Última actualización:** 2025-12-19
