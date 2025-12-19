-- =============================================
-- DATOS SEMILLA PARA SINGLE-TENANT
-- Versión: 1.0
-- Fecha: 2025-12-19
-- Descripción: Datos iniciales para sistema single-tenant
-- =============================================

-- ⚠️ EJECUTAR DESPUÉS DE: 03_simplify_rls_policies.sql

BEGIN;

-- =============================================
-- EMPRESA ÚNICA
-- =============================================

-- Asegurar que existe empresa con datos básicos
INSERT INTO empresas (id, nombre, codigo, logo_url, color_tema, fecha_creacion)
VALUES (
  1, 
  'Mi Empresa', 
  'default',
  NULL,  -- Logo se puede cargar posteriormente
  '#2196F3',  -- Material Blue
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  nombre = COALESCE(EXCLUDED.nombre, empresas.nombre),
  codigo = COALESCE(EXCLUDED.codigo, empresas.codigo);

-- =============================================
-- BRANDING BÁSICO (si la tabla existe)
-- =============================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'empresa_branding') THEN
    EXECUTE 'INSERT INTO empresa_branding (
      empresa_id,
      color_primario,
      color_secundario,
      color_acento,
      fuente_primaria,
      dark_mode_habilitado,
      fecha_creacion,
      actualizado_en
    ) VALUES (
      1,
      ''#1976D2'',  -- Material Blue 700
      ''#DC004E'',  -- Material Pink A400
      ''#FFC107'',  -- Material Amber 500
      ''Roboto'',
      true,
      NOW(),
      NOW()
    )
    ON CONFLICT (empresa_id) DO NOTHING';
    
    RAISE NOTICE 'Branding básico creado';
  END IF;
END $$;

-- =============================================
-- SUCURSAL PRINCIPAL
-- =============================================

-- Crear sucursal principal si no existe
INSERT INTO sucursales (id, empresa_id, nombre, direccion, fecha_creacion)
VALUES (
  1,
  1,
  'Casa Matriz',
  'Dirección principal',
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- TIPOS DE RECLAMO BÁSICOS
-- =============================================

INSERT INTO tipos_reclamo (empresa_id, nombre, descripcion, prioridad_default, activo)
VALUES
  (1, 'General', 'Reclamo general', 'media', true),
  (1, 'Técnico', 'Problema técnico o de producto', 'alta', true),
  (1, 'Servicio', 'Atención al cliente', 'media', true),
  (1, 'Facturación', 'Problema con facturación o cobros', 'alta', true)
ON CONFLICT (empresa_id, nombre) DO NOTHING;

-- =============================================
-- TIPOS DE INTERACCIÓN BÁSICOS
-- =============================================

INSERT INTO tipos_interaccion (empresa_id, nombre, descripcion, activo)
VALUES
  (1, 'Llamada', 'Llamada telefónica', true),
  (1, 'Email', 'Correo electrónico', true),
  (1, 'Reunión', 'Reunión presencial o virtual', true),
  (1, 'WhatsApp', 'Mensaje por WhatsApp', true),
  (1, 'Visita', 'Visita al cliente', true)
ON CONFLICT (empresa_id, nombre) DO NOTHING;

-- =============================================
-- USUARIO ADMINISTRADOR DE EJEMPLO (OPCIONAL)
-- =============================================

-- Nota: Descomentar si quieres crear un usuario admin de prueba
-- Reemplaza 'admin@example.com' y otros valores con tus datos

/*
-- Primero debes crear el usuario vía Supabase Auth, luego ejecutar:
INSERT INTO usuarios (
  id,  -- UUID del usuario creado en Supabase Auth
  email,
  nombre,
  apellido,
  tipo_perfil,
  rol_id,
  empresa_id,
  sucursal_id,
  creado_en
) VALUES (
  'UUID-DEL-USUARIO-AQUI'::uuid,
  'admin@example.com',
  'Admin',
  'Principal',
  'admin',
  (SELECT id FROM roles WHERE nombre = 'admin' LIMIT 1),
  1,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  empresa_id = 1,
  sucursal_id = 1,
  tipo_perfil = 'admin';
*/

-- =============================================
-- FIN
-- =============================================

COMMIT;

-- Resumen
DO $$
DECLARE
  v_empresa record;
  v_sucursales_count int;
  v_tipos_reclamo_count int;
  v_tipos_interaccion_count int;
BEGIN
  SELECT * INTO v_empresa FROM empresas WHERE id = 1;
  SELECT COUNT(*) INTO v_sucursales_count FROM sucursales WHERE empresa_id = 1;
  SELECT COUNT(*) INTO v_tipos_reclamo_count FROM tipos_reclamo WHERE empresa_id = 1;
  SELECT COUNT(*) INTO v_tipos_interaccion_count FROM tipos_interaccion WHERE empresa_id = 1;
  
  RAISE NOTICE '================================================';
  RAISE NOTICE 'DATOS SEMILLA INSERTADOS EXITOSAMENTE';
  RAISE NOTICE '================================================';
  RAISE NOTICE 'Empresa: % (ID: %)', v_empresa.nombre, v_empresa.id;
  RAISE NOTICE 'Sucursales: %', v_sucursales_count;
  RAISE NOTICE 'Tipos de reclamo: %', v_tipos_reclamo_count;
  RAISE NOTICE 'Tipos de interacción: %', v_tipos_interaccion_count;
  RAISE NOTICE '================================================';
  RAISE NOTICE 'Base de datos lista para usar';
  RAISE NOTICE '================================================';
END $$;
