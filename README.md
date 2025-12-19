# Automate Dashboard - Single Tenant

Sistema de gestión empresarial simplificado, diseñado para ser vendido/licenciado a **una empresa a la vez**.

## 📁 Estructura del Proyecto

```
automate-dashboard/
├── app/                    # Aplicación Flutter (frontend)
│   ├── lib/               # Código fuente Dart
│   ├── test/              # Tests unitarios
│   ├── integration_test/  # Tests de integración
│   └── docs/              # Documentación técnica
├── backend/               # Backend Python/FastAPI
│   ├── app/              # Código fuente Python
│   └── tests/            # Tests del backend
├── database/             # Scripts SQL
│   └── migrations/       # Migraciones para single-tenant
└── docs/                 # Documentación del proyecto

```

## 🎯 Características

### 💡 Modelo de Negocio Único
**Single-Tenant + Módulos por Sucursal**

- ✅ **Una empresa** (simplificado, sin multi-tenancy)
- ✅ **Múltiples sucursales** con activación selectiva de módulos
- ✅ **Upsell flexible**: Casa Matriz con acceso completo, sucursales pequeñas solo lo básico
- ✅ **Pruebas piloto**: Activar módulo en 1 sucursal, validar, expandir

**Ejemplo de uso:**
- Casa Matriz: Acceso a todos los módulos
- Sucursal Norte: Solo Clientes + Reclamos
- Sucursal Sur: Clientes + Reclamos + Speech-to-Text

**Monetización:**
- Licencia base: $500-1500 USD
- Módulos adicionales por sucursal: $50-100/mes
- Prueba piloto gratuita para validar valor

### Módulos Incluidos
- ✅ **Dashboard Principal** - Visualización de métricas clave
- ✅ **Gestión de Clientes (CRM)** - Base de clientes completa
- ✅ **Sistema de Reclamos** - Gestión de claims/tickets
- ✅ **Gestión de Personal** - Administración de empleados
- ✅ **Gestión de Sucursales** - Múltiples ubicaciones
- ✅ **Interacciones CRM** - Historial de contactos
- ✅ **Speech-to-Text** - Transcripción de audio (opcional)
- ✅ **Reportes** - Generación automatizada

### Tecnologías
- **Frontend:** Flutter (Web, Desktop, Mobile)
- **Backend:** Python/FastAPI
- **Base de datos:** Supabase (PostgreSQL)
- **State Management:** Riverpod
- **i18n:** Español e Inglés

## 🚀 Guía Rápida

### Requisitos Previos
- Flutter SDK (3.8.1+)
- Python 3.9+
- Cuenta Supabase

### Instalación

#### 1. Base de Datos
```bash
# Ejecutar migraciones en orden:
# 1. database/migrations/02_single_tenant_migration.sql
# 2. database/migrations/03_simplify_rls_policies.sql
# 3. database/migrations/04_seed_single_company.sql
```

Ver guía completa: `database/migrations/README_MIGRATION.md`

#### 2. Backend Python (Opcional - solo si usas Speech-to-Text)
```bash
cd backend
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt

# Configurar .env
cp .env.example .env
# Editar .env con tus credenciales

# Ejecutar
python -m app.main
```

#### 3. Flutter App
```bash
cd app
flutter pub get

# Configurar .env
cp .env.example .env
# Editar .env con tu SUPABASE_URL y SUPABASE_ANON_KEY

# Ejecutar
flutter run
```

## 📖 Documentación

- **[Plan de Refactorización](/.gemini/antigravity/brain/08030cbf-f4d6-4dfe-9d3c-bf5223821b89/refactoring_plan.md)** - Estrategia completa de simplificación
- **[Tareas](/.gemini/antigravity/brain/08030cbf-f4d6-4dfe-9d3c-bf5223821b89/task.md)** - Checklist de implementación
- **[Guía de Migración DB](/database/migrations/README_MIGRATION.md)** - Cómo migrar la base de datos
- **Docs de la App:** Ver `app/docs/`

## 🎯 Modelo de Negocio

### Licencia por Empresa
- **Setup fee:** $300-500 USD
- **Mensual:** $30-50 USD (hosting + soporte)
- **Venta directa:** $500-1500 USD (licencia única)

### Target
- PyMEs locales (10-100 empleados)
- Clínicas, talleres, inmobiliarias, estudios contables
- Empresas que necesitan gestión simple pero efectiva

## 🔧 Estado del Proyecto

### ✅ Completado
- [x] Estructura del proyecto copiada
- [x] Scripts de migración SQL creados
- [x] Backend Python copiado

### 🚧 En Progreso (Sprint 1)
- [ ] Migración de base de datos ejecutada
- [ ] Backend Python simplificado
- [ ] Flutter app refactorizada
- [ ] Tests actualizados

### 📅 Próximos Pasos
1. Ejecutar migración de BD (Sprint 1)
2. Refactorizar backend Python (Sprint 2)
3. Refactorizar Flutter - Core (Sprint 3)
4. Refactorizar Flutter - UI (Sprint 4)
5. Testing & Documentación (Sprint 5)

**Estimado total:** 10-14 días

## 🤝 Contribuir

Este es un proyecto privado. Para cambios mayores, consultar con el equipo.

## 📝 Notas

- **No multi-tenant:** Este proyecto ha sido simplificado para un solo cliente/empresa
- **Código base:** Derivado de `My Smart App Sistema Base` (monorepo)
- **Fecha de inicio refactorización:** 2025-12-19

---

**Versión:** 1.0  
**Última actualización:** 2025-12-19
