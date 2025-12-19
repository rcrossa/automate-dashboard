# Pendientes - Automate Dashboard

## 🔴 CRÍTICO - Antes de Ejecutar

### 1. Configuración de Base de Datos
- [ ] **Ejecutar SQL en Supabase**
  - Archivo: `database/00_single_tenant_schema.sql`
  - Método: Supabase Dashboard → SQL Editor → Copy/Paste → Run
  - Tiempo estimado: 5 minutos
  - Verificación: `SELECT COUNT(*) FROM empresas;` debe retornar 1

### 2. Configuración de Variables de Entorno
- [ ] **Crear archivo `.env`** en `/app/`
  ```env
  SUPABASE_URL=https://tu-proyecto.supabase.co
  SUPABASE_ANON_KEY=tu_anon_key_aqui
  ```
  - Obtener de: Supabase Dashboard → Settings → API
  - Archivo de referencia: `app/.env.example` (crear si no existe)

### 3. Configuración Backend Python (Opcional - Solo si usas Speech-to-Text)
- [ ] **Crear `.env`** en `/backend/`
  ```env
  SUPABASE_URL=https://tu-proyecto.supabase.co
  SUPABASE_SERVICE_KEY=tu_service_key_aqui
  HUGGINGFACE_TOKEN=tu_token_hf (opcional)
  ```
  - Service key: Supabase → Settings → API → service_role key

---

## 🟡 Sprint 4 - UI Limpieza (4-6 horas)

### Screens a Simplificar
- [ ] **Eliminar referencias `super_admin`** en:
  - [x] `pantalla_principal.dart` - ✅ Ya removido
  - [ ] `client_list_screen.dart` - Cambiar `|| 'super_admin'` por solo `'admin'`
  - [ ] `company_dashboard_screen.dart` - Remover checks de super_admin
  - [ ] `company_mobile_layout.dart` - Simplificar checks
  - [ ] `company_desktop_layout.dart` - Simplificar checks
  - [ ] `client_form_dialog.dart` - Simplificar isAdmin check
  - [ ] `claims_list_screen.dart` - Simplificar isManager check

### Carpetas/Módulos a Evaluar
- [ ] **`/screens/super_admin/`**
  - Opción A: Eliminar completamente
  - Opción B: Renombrar a `/screens/admin/` y simplificar

- [ ] **`/screens/company/`**
  - Evaluar si mantener o renombrar a `/screens/admin/`
  - Simplificar lógica de gestión de empresa

### Navegación
- [ ] **App Drawer/Sidebar**
  - Remover opción "Cambiar Empresa" (si existe)
  - Mantener solo "Cambiar Sucursal"

- [ ] **Marketplace de Módulos**
  - UI puede mantenerse
  - Cambiar contexto: "Activar para sucursales" en vez de "para empresas"

---

## 🟢 Sprint 5 - Testing y Docs (2-3 horas)

### Testing
- [ ] **Compilación**
  - [x] Arreglar interfaces de repositories
  - [ ] Ejecutar `flutter analyze`
  - [ ] Resolver warnings (si los hay)

- [ ] **Tests Unitarios**
  - [ ] Ejecutar `flutter test`
  - [ ] Actualizar tests que fallen por cambios de firma
  - [ ] Actualizar mocks si es necesario

- [ ] **Prueba Manual**
  - [ ] Login/Registro
  - [ ] Crear cliente
  - [ ] Crear reclamo
  - [ ] Cambiar sucursal
  - [ ] Verificar módulos por sucursal

### Documentación
- [ ] **README.md**
  - [ ] Actualizar guía de instalación con .env
  - [ ] Mencionar single-tenant explícitamente
  - [ ] Actualizar screenshots (si los hay)

- [ ] **database/README.md**
  - [x] Ya creado ✅

- [ ] **Docs en `/app/docs/`**
  - [ ] Actualizar cualquier mención a multi-tenant
  - [ ] Actualizar diagramas de arquitectura

---

## 📋 Otros Pendientes

### Providers Faltantes
- [ ] **`user_modules_provider.dart`** 
  - Tiene referencias a `empresa_id`
  - Simplificar a solo usar `sucursal_id`

### Module Repository
- [ ] **Actualizar `ModuleRepository`**
  - Método actual: `getActiveModules(companyId, branchId)`
  - Necesita: `getActiveModulesForBranch(branchId)` solamente

### Opcional - Limpieza Final
- [ ] Buscar y remover código muerto
  - `grep -r "super_admin" app/lib/`
  - `grep -r "setCompany" app/lib/`
  - `grep -r "empresa_modulos" app/lib/`

- [ ] Optimizar imports
  - Remover imports no utilizados
  - Ejecutar `flutter pub run import_sorter:main`

---

## ✅ Ya Completado

### Sprint 1: Base de Datos
- [x] Schema SQL single-tenant creado
- [x] Scripts de migración creados
- [x] README de migración
- [x] Políticas RLS simplificadas

### Sprint 3: Flutter Core
- [x] 5 Entities simplificadas (empresaId=1)
- [x] 3 Repositories principales refactorizados
- [x] user_provider simplificado
- [x] module_provider actualizado (sucursal_modulos)

### Commits
- [x] 8 commits pushed a GitHub
- [x] Proyecto en https://github.com/rcrossa/automate-dashboard

---

## 📊 Estimaciones

| Sprint | Tiempo Estimado | Estado |
|--------|----------------|--------|
| Sprint 1: Database | 2-3 días | ✅ Completado |
| Sprint 2: Backend Python | 1-2 días | ⏭️ Saltado (no necesario) |
| Sprint 3: Flutter Core | 3-4 días | ✅ Completado |
| Sprint 4: Flutter UI | 4-6 horas | 🚧 20% completado |
| Sprint 5: Testing | 2-3 horas | ⏸️ Pendiente |
| **TOTAL RESTANTE** | **6-9 horas** | |

---

## 🎯 Prioridades

**Prioridad 1 (Crítico):**
1. Configurar `.env` en `/app/`
2. Ejecutar SQL en Supabase
3. Arreglar referencias `super_admin` en screens

**Prioridad 2 (Importante):**
4. Testing básico
5. Actualizar docs

**Prioridad 3 (Opcional):**
6. Limpieza de código muerto
7. Optimización

---

**Última actualización:** 2025-12-19  
**Versión:** 1.0
