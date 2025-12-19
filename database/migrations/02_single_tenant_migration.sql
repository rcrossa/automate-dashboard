-- =============================================
-- SCRIPT DE MIGRACIÓN: MULTI-TENANT → SINGLE-TENANT
-- Versión: 1.0
-- Fecha: 2025-12-19
-- Descripción: Convierte el sistema multi-tenant actual en single-tenant
-- =============================================

-- ⚠️ IMPORTANTE: Realizar BACKUP completo antes de ejecutar este script
-- pg_dump -U postgres -h localhost -d tu_database > backup_$(date +%Y%m%d_%H%M%S).sql

BEGIN;

-- =============================================
-- PARTE 1: PREPARACIÓN
-- =============================================

-- Verificar que existe al menos una empresa
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM empresas LIMIT 1) THEN
    RAISE EXCEPTION 'No existe ninguna empresa en la base de datos. Cancelando migración.';
  END IF;
END $$;

-- =============================================
-- PARTE 2: EMPRESA ÚNICA
-- =============================================

-- Asegurar que existe empresa con ID = 1
DO $$
DECLARE
  v_empresa_id bigint;
BEGIN
  -- Si no existe empresa con ID 1, usar la primera empresa disponible
  SELECT id INTO v_empresa_id FROM empresas ORDER BY id LIMIT 1;
  
  IF v_empresa_id IS NULL THEN
    -- Crear empresa por defecto
    INSERT INTO empresas (id, nombre, codigo, fecha_creacion)
    VALUES (1, 'Mi Empresa', 'default', NOW())
    ON CONFLICT (id) DO NOTHING;
    v_empresa_id := 1;
  ELSIF v_empresa_id != 1 THEN
    -- Si la primera empresa no es ID 1, necesitamos ajustar
    RAISE NOTICE 'La primera empresa tiene ID %. Se mantendrá como empresa única.', v_empresa_id;
  END IF;
  
  RAISE NOTICE 'Empresa única configurada con ID: %', v_empresa_id;
END $$;

-- Actualizar todos los usuarios para que pertenezcan a la empresa única
UPDATE usuarios 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id IS NULL OR empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar todas las sucursales
UPDATE sucursales 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar todos los reclamos
UPDATE reclamos 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar todas las interacciones
UPDATE interacciones 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id IS NOT NULL AND empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar tipos de reclamo
UPDATE tipos_reclamo 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar tipos de interacción
UPDATE tipos_interaccion 
SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1);

-- Actualizar clientes (si la tabla existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'clientes') THEN
    EXECUTE 'UPDATE clientes 
             SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
             WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1)';
  END IF;
END $$;

-- Actualizar empresa_branding (si existe)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'empresa_branding') THEN
    EXECUTE 'UPDATE empresa_branding 
             SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
             WHERE empresa_id != (SELECT id FROM empresas ORDER BY id LIMIT 1)';
  END IF;
END $$;

-- =============================================
-- PARTE 3: SIMPLIFICAR SISTEMA DE MÓDULOS
-- =============================================

-- MANTENER: modulos, sucursal_modulos (activación por sucursal para pruebas piloto)
-- ELIMINAR: empresa_modulos (multi-tenant), usuario_modulos (granularidad innecesaria)

-- Desactivar RLS temporalmente
ALTER TABLE IF EXISTS usuario_modulos DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS empresa_modulos DISABLE ROW LEVEL SECURITY;

-- Eliminar solo tablas de módulos multi-tenant
DROP TABLE IF EXISTS usuario_modulos CASCADE;
DROP TABLE IF EXISTS empresa_modulos CASCADE;

-- Actualizar sucursal_modulos: asegurar que todas pertenecen a la empresa única
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'sucursal_modulos') THEN
    -- Actualizar empresa_id en sucursales relacionadas
    UPDATE sucursales 
    SET empresa_id = (SELECT id FROM empresas ORDER BY id LIMIT 1)
    WHERE id IN (SELECT DISTINCT sucursal_id FROM sucursal_modulos);
  END IF;
END $$;

RAISE NOTICE 'Sistema de módulos simplificado: Mantenido modulos y sucursal_modulos';

-- =============================================
-- PARTE 4: ELIMINAR SISTEMA DE INVITACIONES
-- =============================================

DROP TABLE IF EXISTS invitaciones CASCADE;

RAISE NOTICE 'Sistema de invitaciones eliminado';

-- =============================================
-- PARTE 5: ELIMINAR EMPRESAS ADICIONALES
-- =============================================

-- Guardar solo la primera empresa
DO $$
DECLARE
  v_empresa_id bigint;
BEGIN
  SELECT id INTO v_empresa_id FROM empresas ORDER BY id LIMIT 1;
  
  -- Eliminar todas las demás empresas
  DELETE FROM empresas WHERE id != v_empresa_id;
  
  RAISE NOTICE 'Eliminadas empresas adicionales. Empresa única: %', v_empresa_id;
END $$;

-- =============================================
-- PARTE 6: SIMPLIFICAR ROLES
-- =============================================

-- Convertir todos los super_admin a admin
UPDATE usuarios 
SET tipo_perfil = 'admin' 
WHERE tipo_perfil = 'super_admin';

-- Actualizar rol_id de super_admin a admin (si existe)
UPDATE usuarios u
SET rol_id = (SELECT id FROM roles WHERE nombre = 'admin' LIMIT 1)
WHERE rol_id = (SELECT id FROM roles WHERE nombre = 'super_admin' LIMIT 1);

-- Eliminar capacidades de super_admin
DELETE FROM rol_capacidad 
WHERE rol_id = (SELECT id FROM roles WHERE nombre = 'super_admin' LIMIT 1);

-- Eliminar rol super_admin
DELETE FROM roles WHERE nombre = 'super_admin';

RAISE NOTICE 'Rol super_admin eliminado, usuarios convertidos a admin';

-- =============================================
-- PARTE 7: ELIMINAR FUNCIONES MULTI-TENANT
-- =============================================

-- Eliminar funciones obsoletas
DROP FUNCTION IF EXISTS public.mi_empresa_id() CASCADE;
DROP FUNCTION IF EXISTS public.es_super_admin() CASCADE;

RAISE NOTICE 'Funciones multi-tenant eliminadas';

-- =============================================
-- PARTE 8: ACTUALIZAR FUNCIÓN es_admin()
-- =============================================

-- Simplificar función es_admin (ya no necesita verificar super_admin)
CREATE OR REPLACE FUNCTION public.es_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM usuarios u
    LEFT JOIN roles r ON u.rol_id = r.id
    WHERE u.id = auth.uid() 
    AND (
      u.tipo_perfil = 'admin'
      OR r.nombre = 'admin'
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

RAISE NOTICE 'Función es_admin() simplificada';

-- =============================================
-- PARTE 9: ACTUALIZAR TRIGGER handle_new_user()
-- =============================================

-- Simplificar trigger para asignar automáticamente empresa_id = primera empresa
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_rol_id integer;
  v_empresa_id bigint;
BEGIN
  -- Obtener la empresa única
  SELECT id INTO v_empresa_id FROM public.empresas ORDER BY id LIMIT 1;
  
  -- Obtener rol 'usuario' por defecto
  SELECT id INTO v_rol_id FROM public.roles WHERE nombre = 'usuario' LIMIT 1;
  
  -- Insertar usuario con empresa hardcodeada
  INSERT INTO public.usuarios (
    id, 
    email, 
    username, 
    nombre, 
    apellido, 
    telefono, 
    direccion, 
    documento_identidad, 
    tipo_perfil, 
    rol_id,
    empresa_id  -- ← Asignar automáticamente
  ) VALUES (
    NEW.id, 
    NEW.email, 
    NEW.raw_user_meta_data->>'username', 
    COALESCE(NEW.raw_user_meta_data->>'nombre', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'apellido',
    NEW.raw_user_meta_data->>'telefono',
    NEW.raw_user_meta_data->>'direccion',
    NEW.raw_user_meta_data->>'documento_identidad',
    'usuario',
    v_rol_id,
    v_empresa_id  -- ← Hardcodeado
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

RAISE NOTICE 'Trigger handle_new_user() actualizado para single-tenant';

-- =============================================
-- FIN DE MIGRACIÓN
-- =============================================

COMMIT;

-- Mostrar resumen
DO $$
DECLARE
  v_empresa record;
  v_usuarios_count int;
  v_sucursales_count int;
BEGIN
  SELECT * INTO v_empresa FROM empresas ORDER BY id LIMIT 1;
  SELECT COUNT(*) INTO v_usuarios_count FROM usuarios;
  SELECT COUNT(*) INTO v_sucursales_count FROM sucursales;
  
  RAISE NOTICE '================================================';
  RAISE NOTICE 'MIGRACIÓN COMPLETADA EXITOSAMENTE';
  RAISE NOTICE '================================================';
  RAISE NOTICE 'Empresa única: ID=%, Nombre=%, Código=%', v_empresa.id, v_empresa.nombre, v_empresa.codigo;
  RAISE NOTICE 'Total usuarios: %', v_usuarios_count;
  RAISE NOTICE 'Total sucursales: %', v_sucursales_count;
  RAISE NOTICE '================================================';
  RAISE NOTICE 'Siguiente paso: Ejecutar 03_simplify_rls_policies.sql';
  RAISE NOTICE '================================================';
END $$;
