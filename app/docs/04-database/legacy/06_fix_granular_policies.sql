-- ===========================================
-- FIX: POLICIES FOR GRANULAR MODULES (SUPER ADMIN)
-- ===========================================

-- 1. Drop existing restrictive policies
DROP POLICY IF EXISTS "Admin gestiona módulos de sucursales" ON sucursal_modulos;
DROP POLICY IF EXISTS "Admin gestiona módulos de usuarios" ON usuario_modulos;

-- 2. Re-create policies with explicit Super Admin bypass

-- POLICY: Admin (y Super Admin) gestiona módulos de sucursales
CREATE POLICY "Admin gestiona módulos de sucursales" ON sucursal_modulos
    FOR ALL
    USING (
        public.es_super_admin() -- Super Admin Global puede gestionar todo
        OR
        sucursal_id IN (
            SELECT id FROM sucursales WHERE empresa_id IN (
                SELECT empresa_id FROM usuarios WHERE id = auth.uid() AND tipo_perfil = 'admin'
            )
        )
    );

-- POLICY: Admin (y Super Admin) gestiona módulos de usuarios
CREATE POLICY "Admin gestiona módulos de usuarios" ON usuario_modulos
    FOR ALL
    USING (
        public.es_super_admin() -- Super Admin Global puede gestionar todo
        OR
        usuario_id IN (
            SELECT id FROM usuarios WHERE empresa_id IN (
                SELECT empresa_id FROM usuarios WHERE id = auth.uid() AND tipo_perfil = 'admin'
            )
        )
    );

-- 3. Asegurar que las policies de lectura también incluyan al Super Admin
DROP POLICY IF EXISTS "Ver módulos de mi sucursal" ON sucursal_modulos;
CREATE POLICY "Ver módulos de mi sucursal" ON sucursal_modulos
    FOR SELECT
    USING (
        public.es_super_admin()
        OR
        sucursal_id IN (
            SELECT sucursal_id FROM usuarios WHERE id = auth.uid()
        )
        OR
        sucursal_id IN (
            SELECT id FROM sucursales WHERE empresa_id IN (
                SELECT empresa_id FROM usuarios WHERE id = auth.uid() AND tipo_perfil = 'admin'
            )
        )
    );

DROP POLICY IF EXISTS "Ver módulos propios" ON usuario_modulos;
CREATE POLICY "Ver módulos propios" ON usuario_modulos
    FOR SELECT
    USING (
        public.es_super_admin()
        OR
        usuario_id = auth.uid()
        OR
        usuario_id IN (
            SELECT id FROM usuarios WHERE empresa_id IN (
                SELECT empresa_id FROM usuarios WHERE id = auth.uid() AND tipo_perfil = 'admin'
            )
        )
    );
