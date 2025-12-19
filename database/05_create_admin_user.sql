-- ============================================
-- CREAR USUARIO ADMINISTRADOR
-- ============================================
-- Este script crea un usuario administrador para testing
-- IMPORTANTE: Ejecutar DESPUÉS de crear el usuario en Supabase Auth Dashboard

-- Opción 1: RECOMENDADA
-- =====================
-- 1. Ve a Supabase Dashboard → Authentication → Users
-- 2. Click "Add user" → "Create new user"
-- 3. Email: admin@automate.com
-- 4. Password: Admin123! (o la que prefieras)
-- 5. Auto Confirm User: YES
-- 6. Copia el UUID que se genera
-- 7. Ejecuta este script reemplazando 'USER_UUID_AQUI' con el UUID

-- Opción 2: SQL Directo (Requiere service_role key)
-- ===================================================
-- Si tienes acceso al service_role, puedes crear el usuario directamente:
-- (Comentado por seguridad, descomenta si lo necesitas)

/*
-- Crear usuario en auth.users
INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    gen_random_uuid(),  -- Se generará automáticamente
    '00000000-0000-0000-0000-000000000000',
    'admin@automate.com',
    crypt('Admin123!', gen_salt('bf')),  -- Password hasheado
    NOW(),
    '{"provider":"email","providers":["email"]}',
    '{}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);
*/

-- ============================================
-- INSERTAR EN TABLA USUARIOS
-- ============================================
-- Reemplaza 'USER_UUID_AQUI' con el UUID del usuario de Supabase Auth

-- Verificar que existe la empresa
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM empresas WHERE id = 1) THEN
        RAISE EXCEPTION 'Error: No existe la empresa con id=1. Ejecuta primero 00_single_tenant_schema.sql';
    END IF;
END $$;

-- Verificar que existe el rol admin
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM roles WHERE nombre = 'admin') THEN
        RAISE EXCEPTION 'Error: No existe el rol admin. Ejecuta primero 00_single_tenant_schema.sql';
    END IF;
END $$;

-- Insertar usuario administrador
-- ⚠️ REEMPLAZA 'USER_UUID_AQUI' con el UUID real del usuario de Supabase Auth
INSERT INTO usuarios (
    id,
    email,
    username,
    nombre,
    apellido,
    telefono,
    tipo_perfil,
    rol_id,
    empresa_id,
    sucursal_id
) VALUES (
    'USER_UUID_AQUI',  -- ⚠️ REEMPLAZAR con UUID de Supabase Auth
    'admin@automate.com',
    'admin',
    'Administrador',
    'Sistema',
    '+1234567890',
    'admin',
    (SELECT id FROM roles WHERE nombre = 'admin'),
    1,  -- Empresa única
    (SELECT id FROM sucursales WHERE empresa_id = 1 LIMIT 1)  -- Primera sucursal
)
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    username = EXCLUDED.username,
    nombre = EXCLUDED.nombre,
    apellido = EXCLUDED.apellido,
    tipo_perfil = EXCLUDED.tipo_perfil,
    rol_id = EXCLUDED.rol_id,
    empresa_id = EXCLUDED.empresa_id,
    sucursal_id = EXCLUDED.sucursal_id;

-- Verificar inserción
SELECT 
    u.id,
    u.email,
    u.nombre,
    u.apellido,
    r.nombre as rol,
    u.empresa_id,
    u.sucursal_id
FROM usuarios u
LEFT JOIN roles r ON u.rol_id = r.id
WHERE u.email = 'admin@automate.com';

-- ============================================
-- CREDENCIALES DE ACCESO
-- ============================================
-- Email: admin@automate.com
-- Password: Admin123! (o la que configuraste)
