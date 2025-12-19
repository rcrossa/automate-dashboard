-- Migration: Expandir opciones de theming
-- Fecha: 2025-12-13
-- Descripción: Agregar más columnas de colores y opciones de tipografía

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

-- Espaciado y bordes (opcional, para futuro)
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS espaciado_base INTEGER DEFAULT 16;
ALTER TABLE empresa_branding ADD COLUMN IF NOT EXISTS radio_bordes INTEGER DEFAULT 8;

-- Comentarios
COMMENT ON COLUMN empresa_branding.color_fondo IS 'Color de fondo principal (light mode)';
COMMENT ON COLUMN empresa_branding.color_texto IS 'Color de texto principal (light mode)';
COMMENT ON COLUMN empresa_branding.color_error IS 'Color para estados de error';
COMMENT ON COLUMN empresa_branding.color_exito IS 'Color para estados de éxito';
COMMENT ON COLUMN empresa_branding.color_advertencia IS 'Color para warnings';
COMMENT ON COLUMN empresa_branding.color_info IS 'Color para mensajes informativos';
