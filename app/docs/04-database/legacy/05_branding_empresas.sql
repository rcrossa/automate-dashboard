-- ===========================================
-- MIGRACIÓN: BRANDING DE EMPRESAS
-- ===========================================

-- Agregar columnas de personalización visual a la tabla empresas
ALTER TABLE empresas 
ADD COLUMN IF NOT EXISTS logo_url TEXT,
ADD COLUMN IF NOT EXISTS color_tema TEXT DEFAULT '#2196F3'; -- Azul por defecto

-- Actualizar la empresa demo con un color distintivo (ej: Verde)
UPDATE empresas 
SET color_tema = '#4CAF50', logo_url = 'https://via.placeholder.com/150'
WHERE codigo = 'demo';
