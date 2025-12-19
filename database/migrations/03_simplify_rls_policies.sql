-- =============================================
-- SIMPLIFICACIÓN DE RLS POLICIES - SINGLE TENANT
-- Versión: 1.0
-- Fecha: 2025-12-19
-- Descripción: Simplifica todas las policies RLS para arquitectura single-tenant
-- =============================================

-- ⚠️ EJECUTAR DESPUÉS DE: 02_single_tenant_migration.sql

BEGIN;

-- =============================================
-- EMPRESAS
-- =============================================

-- Todos los usuarios autenticados pueden ver la empresa
DROP POLICY IF EXISTS "select_empresas_unificada" ON empresas;
DROP POLICY IF EXISTS "select_empresas_simple" ON empresas;
CREATE POLICY "select_empresas_simple" ON empresas
FOR SELECT TO authenticated USING (true);

-- Solo admins pueden actualizar la empresa
DROP POLICY IF EXISTS "update_empresas_unificada" ON empresas;
DROP POLICY IF EXISTS "update_empresas_simple" ON empresas;
CREATE POLICY "update_empresas_simple" ON empresas
FOR UPDATE TO authenticated 
USING ((SELECT public.es_admin()))
WITH CHECK ((SELECT public.es_admin()));

-- No se pueden insertar más empresas
DROP POLICY IF EXISTS "insert_empresas_unificada" ON empresas;
DROP POLICY IF EXISTS "insert_empresas_simple" ON empresas;
CREATE POLICY "insert_empresas_simple" ON empresas
FOR INSERT TO authenticated WITH CHECK (false);

-- No se pueden eliminar empresas
DROP POLICY IF EXISTS "delete_empresas_unificada" ON empresas;
DROP POLICY IF EXISTS "delete_empresas_simple" ON empresas;
CREATE POLICY "delete_empresas_simple" ON empresas
FOR DELETE TO authenticated USING (false);

-- =============================================
-- SUCURSALES
-- =============================================

DROP POLICY IF EXISTS "select_sucursales_unificada" ON sucursales;
DROP POLICY IF EXISTS "select_sucursales_simple" ON sucursales;
CREATE POLICY "select_sucursales_simple" ON sucursales
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_sucursales_unificada" ON sucursales;
DROP POLICY IF EXISTS "insert_sucursales_simple" ON sucursales;
CREATE POLICY "insert_sucursales_simple" ON sucursales
FOR INSERT TO authenticated WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "update_sucursales_unificada" ON sucursales;
DROP POLICY IF EXISTS "update_sucursales_simple" ON sucursales;
CREATE POLICY "update_sucursales_simple" ON sucursales
FOR UPDATE TO authenticated 
USING ((SELECT public.es_admin()))
WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "delete_sucursales_unificada" ON sucursales;
DROP POLICY IF EXISTS "delete_sucursales_simple" ON sucursales;
CREATE POLICY "delete_sucursales_simple" ON sucursales
FOR DELETE TO authenticated USING ((SELECT public.es_admin()));

-- =============================================
-- USUARIOS
-- =============================================

DROP POLICY IF EXISTS "select_usuarios_unificada" ON usuarios;
DROP POLICY IF EXISTS "select_usuarios_simple" ON usuarios;
CREATE POLICY "select_usuarios_simple" ON usuarios
FOR SELECT TO authenticated USING (
  id = (SELECT auth.uid()) OR (SELECT public.es_admin())
);

DROP POLICY IF EXISTS "update_usuarios_unificada" ON usuarios;
DROP POLICY IF EXISTS "update_usuarios_simple" ON usuarios;
CREATE POLICY "update_usuarios_simple" ON usuarios
FOR UPDATE TO authenticated 
USING (id = (SELECT auth.uid()) OR (SELECT public.es_admin()))
WITH CHECK (id = (SELECT auth.uid()) OR (SELECT public.es_admin()));

DROP POLICY IF EXISTS "delete_usuarios_unificada" ON usuarios;
DROP POLICY IF EXISTS "delete_usuarios_simple" ON usuarios;
CREATE POLICY "delete_usuarios_simple" ON usuarios
FOR DELETE TO authenticated USING ((SELECT public.es_admin()));

-- =============================================
-- INTERACCIONES
-- =============================================

DROP POLICY IF EXISTS "select_interacciones_unificada" ON interacciones;
DROP POLICY IF EXISTS "select_interacciones_simple" ON interacciones;
CREATE POLICY "select_interacciones_simple" ON interacciones
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_interacciones_unificada" ON interacciones;
DROP POLICY IF EXISTS "insert_interacciones_simple" ON interacciones;
CREATE POLICY "insert_interacciones_simple" ON interacciones
FOR INSERT TO authenticated WITH CHECK (true);

-- =============================================
-- RECLAMOS
-- =============================================

DROP POLICY IF EXISTS "select_reclamos_unificada" ON reclamos;
DROP POLICY IF EXISTS "select_reclamos_simple" ON reclamos;
DROP POLICY IF EXISTS "Gestionar reclamos de mi empresa" ON reclamos;
CREATE POLICY "select_reclamos_simple" ON reclamos
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_reclamos_unificada" ON reclamos;
DROP POLICY IF EXISTS "insert_reclamos_simple" ON reclamos;
CREATE POLICY "insert_reclamos_simple" ON reclamos
FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_reclamos_unificada" ON reclamos;
DROP POLICY IF EXISTS "update_reclamos_simple" ON reclamos;
CREATE POLICY "update_reclamos_simple" ON reclamos
FOR UPDATE TO authenticated 
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "delete_reclamos_unificada" ON reclamos;
DROP POLICY IF EXISTS "delete_reclamos_simple" ON reclamos;
CREATE POLICY "delete_reclamos_simple" ON reclamos
FOR DELETE TO authenticated USING ((SELECT public.es_admin()));

-- =============================================
-- TIPOS DE RECLAMO
-- =============================================

DROP POLICY IF EXISTS "select_tipos_reclamo_unificada" ON tipos_reclamo;
DROP POLICY IF EXISTS "select_tipos_reclamo_simple" ON tipos_reclamo;
CREATE POLICY "select_tipos_reclamo_simple" ON tipos_reclamo
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_tipos_reclamo_unificada" ON tipos_reclamo;
DROP POLICY IF EXISTS "insert_tipos_reclamo_simple" ON tipos_reclamo;
CREATE POLICY "insert_tipos_reclamo_simple" ON tipos_reclamo
FOR INSERT TO authenticated WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "update_tipos_reclamo_unificada" ON tipos_reclamo;
DROP POLICY IF EXISTS "update_tipos_reclamo_simple" ON tipos_reclamo;
CREATE POLICY "update_tipos_reclamo_simple" ON tipos_reclamo
FOR UPDATE TO authenticated 
USING ((SELECT public.es_admin()))
WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "delete_tipos_reclamo_unificada" ON tipos_reclamo;
DROP POLICY IF EXISTS "delete_tipos_reclamo_simple" ON tipos_reclamo;
CREATE POLICY "delete_tipos_reclamo_simple" ON tipos_reclamo
FOR DELETE TO authenticated USING ((SELECT public.es_admin()));

-- =============================================
-- TIPOS DE INTERACCIÓN
-- =============================================

DROP POLICY IF EXISTS "select_tipos_interaccion_unificada" ON tipos_interaccion;
DROP POLICY IF EXISTS "select_tipos_interaccion_simple" ON tipos_interaccion;
CREATE POLICY "select_tipos_interaccion_simple" ON tipos_interaccion
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_tipos_interaccion_unificada" ON tipos_interaccion;
DROP POLICY IF EXISTS "insert_tipos_interaccion_simple" ON tipos_interaccion;
CREATE POLICY "insert_tipos_interaccion_simple" ON tipos_interaccion
FOR INSERT TO authenticated WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "update_tipos_interaccion_unificada" ON tipos_interaccion;
DROP POLICY IF EXISTS "update_tipos_interaccion_simple" ON tipos_interaccion;
CREATE POLICY "update_tipos_interaccion_simple" ON tipos_interaccion
FOR UPDATE TO authenticated 
USING ((SELECT public.es_admin()))
WITH CHECK ((SELECT public.es_admin()));

DROP POLICY IF EXISTS "delete_tipos_interaccion_unificada" ON tipos_interaccion;
DROP POLICY IF EXISTS "delete_tipos_interaccion_simple" ON tipos_interaccion;
CREATE POLICY "delete_tipos_interaccion_simple" ON tipos_interaccion
FOR DELETE TO authenticated USING ((SELECT public.es_admin()));

-- =============================================
-- HISTORIAL RECLAMOS
-- =============================================

DROP POLICY IF EXISTS "select_historial_reclamos_unificada" ON historial_reclamos;
DROP POLICY IF EXISTS "select_historial_reclamos_simple" ON historial_reclamos;
CREATE POLICY "select_historial_reclamos_simple" ON historial_reclamos
FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_historial_reclamos_unificada" ON historial_reclamos;
DROP POLICY IF EXISTS "insert_historial_reclamos_simple" ON historial_reclamos;
CREATE POLICY "insert_historial_reclamos_simple" ON historial_reclamos
FOR INSERT TO authenticated WITH CHECK (true);

-- =============================================
-- CLIENTES (si existe)
-- =============================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'clientes') THEN
    EXECUTE 'DROP POLICY IF EXISTS "select_clientes_unificada" ON clientes';
    EXECUTE 'DROP POLICY IF EXISTS "select_clientes_simple" ON clientes';
    EXECUTE 'CREATE POLICY "select_clientes_simple" ON clientes FOR SELECT TO authenticated USING (true)';
    
    EXECUTE 'DROP POLICY IF EXISTS "insert_clientes_unificada" ON clientes';
    EXECUTE 'DROP POLICY IF EXISTS "insert_clientes_simple" ON clientes';
    EXECUTE 'CREATE POLICY "insert_clientes_simple" ON clientes FOR INSERT TO authenticated WITH CHECK (true)';
    
    EXECUTE 'DROP POLICY IF EXISTS "update_clientes_unificada" ON clientes';
    EXECUTE 'DROP POLICY IF EXISTS "update_clientes_simple" ON clientes';
    EXECUTE 'CREATE POLICY "update_clientes_simple" ON clientes FOR UPDATE TO authenticated USING (true) WITH CHECK (true)';
    
    EXECUTE 'DROP POLICY IF EXISTS "delete_clientes_unificada" ON clientes';
    EXECUTE 'DROP POLICY IF EXISTS "delete_clientes_simple" ON clientes';
    EXECUTE 'CREATE POLICY "delete_clientes_simple" ON clientes FOR DELETE TO authenticated USING ((SELECT public.es_admin()))';
    
    RAISE NOTICE 'Policies de clientes simplificadas';
  END IF;
END $$;

-- =============================================
-- EMPRESA BRANDING (si existe)
-- =============================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'empresa_branding') THEN
    EXECUTE 'DROP POLICY IF EXISTS "select_empresa_branding_unificada" ON empresa_branding';
    EXECUTE 'DROP POLICY IF EXISTS "select_empresa_branding_simple" ON empresa_branding';
    EXECUTE 'CREATE POLICY "select_empresa_branding_simple" ON empresa_branding FOR SELECT TO authenticated USING (true)';
    
    EXECUTE 'DROP POLICY IF EXISTS "update_empresa_branding_unificada" ON empresa_branding';
    EXECUTE 'DROP POLICY IF EXISTS "update_empresa_branding_simple" ON empresa_branding';
    EXECUTE 'CREATE POLICY "update_empresa_branding_simple" ON empresa_branding FOR UPDATE TO authenticated USING ((SELECT public.es_admin())) WITH CHECK ((SELECT public.es_admin()))';
    
    RAISE NOTICE 'Policies de empresa_branding simplificadas';
  END IF;
END $$;

-- =============================================
-- ROLES/CAPACIDADES/PERMISOS (mantener como están)
-- =============================================

-- Estas policies ya son simples, solo verificamos que existan

DROP POLICY IF EXISTS "select_roles_unificada" ON roles;
DROP POLICY IF EXISTS "select_roles_simple" ON roles;
CREATE POLICY "select_roles_simple" ON roles FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "select_capacidades_unificada" ON capacidades;
DROP POLICY IF EXISTS "select_capacidades_simple" ON capacidades;
CREATE POLICY "select_capacidades_simple" ON capacidades FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "select_permisos_unificada" ON permisos;
DROP POLICY IF EXISTS "select_permisos_simple" ON permisos;
CREATE POLICY "select_permisos_simple" ON permisos FOR SELECT TO authenticated USING (true);

-- =============================================
-- FIN
-- =============================================

COMMIT;

RAISE NOTICE '================================================';
RAISE NOTICE 'RLS POLICIES SIMPLIFICADAS EXITOSAMENTE';
RAISE NOTICE '================================================';
RAISE NOTICE 'Todas las policies ahora permiten acceso a todos los usuarios autenticados';
RAISE NOTICE 'Las restricciones de empresa_id han sido eliminadas';
RAISE NOTICE '================================================';
RAISE NOTICE 'Siguiente paso: Actualizar Backend Python';
RAISE NOTICE '================================================';
