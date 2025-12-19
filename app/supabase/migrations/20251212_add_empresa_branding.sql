-- Migration: Add empresa_branding table for multi-tenant theming
-- Date: 2025-12-12
-- Description: Allows each company to customize their app appearance

CREATE TABLE IF NOT EXISTS empresa_branding (
  id SERIAL PRIMARY KEY,
  empresa_id INTEGER REFERENCES empresas(id) ON DELETE CASCADE UNIQUE NOT NULL,
  
  -- Colores (formato hex: #RRGGBB)
  color_primario VARCHAR(7) DEFAULT '#1976D2' NOT NULL,  -- Azul Material
  color_secundario VARCHAR(7) DEFAULT '#DC004E' NOT NULL, -- Rosa Material
  color_acento VARCHAR(7) DEFAULT '#FFC107' NOT NULL,     -- Ámbar
  
  -- Logo URL (Supabase Storage)
  logo_url TEXT,
  logo_light_url TEXT,  -- Logo para dark mode (opcional)
  
  -- Favicon/App Icon
  favicon_url TEXT,
  
  -- Tipografía
  fuente_primaria VARCHAR(50) DEFAULT 'Roboto' NOT NULL,
  
  -- Dark Mode
  dark_mode_habilitado BOOLEAN DEFAULT true NOT NULL,
  color_primario_dark VARCHAR(7),
  color_secundario_dark VARCHAR(7),
  
  -- Timestamps
  fecha_creacion TIMESTAMP DEFAULT NOW() NOT NULL,
  actualizado_en TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Índices
CREATE INDEX idx_empresa_branding_empresa ON empresa_branding(empresa_id);

-- Trigger para actualizar timestamp
CREATE OR REPLACE FUNCTION update_empresa_branding_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.actualizado_en = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER empresa_branding_updated
  BEFORE UPDATE ON empresa_branding
  FOR EACH ROW
  EXECUTE FUNCTION update_empresa_branding_timestamp();

-- RLS Policies
ALTER TABLE empresa_branding ENABLE ROW LEVEL SECURITY;

-- Policy: Solo admins y super_admins pueden editar branding de su empresa
CREATE POLICY "Only admins can manage their company branding"
  ON empresa_branding
  FOR ALL
  USING (
    empresa_id IN (
      SELECT u.empresa_id 
      FROM usuarios u
      INNER JOIN roles r ON u.rol_id = r.id  -- Corregido: rol_id no role_id
      WHERE u.id = auth.uid()
        AND r.nombre IN ('admin', 'super_admin')
    )
  );

-- Policy: Todos los usuarios pueden ver branding de su empresa
CREATE POLICY "Users can view their company branding"
  ON empresa_branding
  FOR SELECT
  USING (
    empresa_id IN (
      SELECT empresa_id 
      FROM usuarios 
      WHERE id = auth.uid()
    )
  );

-- Insertar branding por defecto para empresas existentes
INSERT INTO empresa_branding (empresa_id)
SELECT id FROM empresas
WHERE id NOT IN (SELECT empresa_id FROM empresa_branding)
ON CONFLICT (empresa_id) DO NOTHING;

-- Comentarios
COMMENT ON TABLE empresa_branding IS 'Almacena la configuración de branding personalizado por empresa para theming multi-tenant';
COMMENT ON COLUMN empresa_branding.color_primario IS 'Color primario de la empresa en formato hex (#RRGGBB)';
COMMENT ON COLUMN empresa_branding.logo_url IS 'URL del logo de la empresa almacenado en Supabase Storage';
COMMENT ON COLUMN empresa_branding.dark_mode_habilitado IS 'Indica si la empresa permite modo oscuro';
