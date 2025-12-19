-- ===========================================
-- SCRIPT DE DATOS SEMILLA (SEED DATA)
-- Ejecutar esto para crear la primera empresa y usuario admin
-- ===========================================

-- 1. Crear Empresa
INSERT INTO empresas (nombre, codigo) 
VALUES ('Mi Empresa Demo', 'demo')
ON CONFLICT (codigo) DO NOTHING;

-- 2. Crear Sucursal (Casa Matriz)
INSERT INTO sucursales (empresa_id, nombre, direccion)
SELECT id, 'Casa Matriz', 'Calle Falsa 123'
FROM empresas WHERE codigo = 'demo'
ON CONFLICT DO NOTHING;

-- 3. Configurar tu usuario como Super Admin y asignar permisos
-- Reemplaza 'TU_EMAIL_AQUI' por tu email real
DO $$
DECLARE
    v_user_email text := 'TU_EMAIL_AQUI'; -- <--- PON TU EMAIL AQUI
    v_user_id uuid;
BEGIN
    -- Obtener ID del usuario
    SELECT id INTO v_user_id FROM auth.users WHERE email = v_user_email;

    IF v_user_id IS NOT NULL THEN
        -- 0. Verificar si existe un usuario con el mismo email pero diferente ID (Error de sincronización)
        DELETE FROM public.usuarios 
        WHERE email = v_user_email AND id != v_user_id;

        -- 1. Asegurar que existe en public.usuarios (Sincronización)
        INSERT INTO public.usuarios (id, email, nombre, tipo_perfil, rol_id)
        VALUES (
            v_user_id, 
            v_user_email, 
            'Super Admin', 
            'super_admin', 
            (SELECT id FROM roles WHERE nombre = 'super_admin')
        )
        ON CONFLICT (id) DO UPDATE SET 
            tipo_perfil = 'super_admin',
            rol_id = (SELECT id FROM roles WHERE nombre = 'super_admin'),
            empresa_id = (SELECT id FROM empresas WHERE codigo = 'demo'),
            sucursal_id = (SELECT id FROM sucursales WHERE empresa_id = (SELECT id FROM empresas WHERE codigo = 'demo') LIMIT 1);

        -- 2. Asignar TODOS los permisos
        INSERT INTO usuario_permiso (usuario_id, permiso_id)
        SELECT v_user_id, id FROM permisos
        ON CONFLICT (usuario_id, permiso_id) DO NOTHING;
        
        RAISE NOTICE 'Usuario % configurado como Super Admin con todos los permisos.', v_user_email;
    ELSE
        RAISE WARNING 'No se encontró el usuario con email %. Asegúrate de haberte registrado primero.', v_user_email;
    END IF;
END $$;
