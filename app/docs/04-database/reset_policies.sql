-- ==============================================================================
-- SCRIPT DE RESETEO DE POLÍTICAS (NUCLEAR)
-- EJECUTAR ESTO PRIMERO.
-- Este script recorre todas las tablas gestionadas y elimina TODAS las politicas RLS existentes.
-- ==============================================================================

DO $$
DECLARE
  r RECORD;
  tables_to_clean TEXT[] := ARRAY[
    'empresas', 
    'sucursales', 
    'usuarios', 
    'invitaciones', 
    'clientes', 
    'reclamos', 
    'interacciones', 
    'historial_reclamos', 
    'modulos', 
    'empresa_modulos', 
    'sucursal_modulos', 
    'usuario_modulos', 
    'roles', 
    'capacidades', 
    'permisos', 
    'rol_capacidad', 
    'usuario_permiso', 
    'tipos_reclamo', 
    'tipos_interaccion'
  ];
BEGIN
  -- Recorre todas las politicas encontradas en el esquema public
  FOR r IN 
    SELECT policyname, tablename 
    FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = ANY(tables_to_clean)
  LOOP
    -- Ejecuta el drop individualmente
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I CASCADE', r.policyname, r.tablename);
    RAISE NOTICE 'Politica eliminada: % ON %', r.policyname, r.tablename;
  END LOOP;
END $$;
