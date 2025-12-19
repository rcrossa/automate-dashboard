# 🚀 INSTRUCCIONES SQL - Theming Expandido

## Ejecutar en Supabase Dashboard

**Antes de continuar con la próxima sesión, debes ejecutar esta migration SQL**

---

### Paso 1: Abrir SQL Editor

1. Ve a: [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecciona tu proyecto
3. Click en **SQL Editor** (menú lateral izquierdo)
4. Click en **New Query**

---

### Paso 2: Copiar y Pegar SQL

Copia TODO el contenido de este archivo:

📁 **Archivo**: `docs/database/migrations/20251213_expand_theming.sql`

O copia este SQL directamente:

```sql
-- Migration: Expandir opciones de theming
-- Fecha: 2025-12-13

-- Colores adicionales para light mode
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_fondo VARCHAR(7) DEFAULT '#FFFFFF';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_texto VARCHAR(7) DEFAULT '#1F2937';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_error VARCHAR(7) DEFAULT '#EF4444';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_exito VARCHAR(7) DEFAULT '#10B981';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_advertencia VARCHAR(7) DEFAULT '#F59E0B';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_info VARCHAR(7) DEFAULT '#3B82F6';

-- Colores adicionales para dark mode
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_fondo_dark VARCHAR(7) DEFAULT '#1F2937';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_texto_dark VARCHAR(7) DEFAULT '#F9FAFB';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_error_dark VARCHAR(7) DEFAULT '#F87171';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_exito_dark VARCHAR(7) DEFAULT '#34D399';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_advertencia_dark VARCHAR(7) DEFAULT '#FBBF24';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS color_info_dark VARCHAR(7) DEFAULT '#60A5FA';

-- Tipografía avanzada
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS fuente_secundaria VARCHAR(100) DEFAULT 'Roboto';
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS tamano_texto_base INTEGER DEFAULT 16;
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS tamano_header INTEGER DEFAULT 28;

-- Espaciado y bordes
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS espaciado_base INTEGER DEFAULT 16;
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS radio_bordes INTEGER DEFAULT 8;

-- Comentarios
COMMENT ON COLUMN empresa_branding.color_fondo IS 'Color de fondo principal (light mode)';
COMMENT ON COLUMN empresa_branding.color_texto IS 'Color de texto principal (light mode)';
COMMENT ON COLUMN empresa_branding.color_error IS 'Color para estados de error';
COMMENT ON COLUMN empresa_branding.fuente_secundaria IS 'Fuente utilizada para headers y títulos';
```

---

### Paso 3: Ejecutar

1. Pega el SQL en el editor
2. Click en **RUN** (botón verde inferior derecha)
3. Espera confirmación: "Success. No rows returned"

---

### Paso 4: Verificar

Ejecuta esta query para verificar que las columnas se agregaron:

```sql
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'empresa_branding'
AND column_name LIKE '%color%'
ORDER BY ordinal_position;
```

Deberías ver las 12 nuevas columnas de color.

---

## ✅ Listo!

Una vez ejecutado el SQL, puedes continuar con la implementación de la UI en la próxima sesión.

Los valores por defecto ya están configurados, así que las filas existentes en `empresa_branding` tendrán valores razonables automáticamente.

---

## 🔗 Referencias

- **Migration File**: `docs/database/migrations/20251213_expand_theming.sql`
- **Schema Completo**: `docs/database/schema.sql` (actualizado con esta migration)
- **Walkthrough**: `brain/.../walkthrough_sesion_completa.md`
- **Pendientes**: `docs/pendientes.md`
