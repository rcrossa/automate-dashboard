# Cómo Crear Usuario Administrador

## Método Recomendado (Supabase Dashboard)

### Paso 1: Crear en Supabase Auth
1. Ve a **Supabase Dashboard**
2. **Authentication** → **Users**
3. Click **"Add user"** → **"Create new user"**
4. Completa:
   - **Email:** `admin@automate.com`
   - **Password:** `Admin123!` (o la que prefieras)
   - **Auto Confirm User:** ✅ YES (importante!)
5. Click **"Create user"**
6. **Copia el UUID** que aparece (ej: `a1b2c3d4-e5f6-...`)

### Paso 2: Insertar en Tabla Usuarios
1. Ve a **SQL Editor**
2. Abre el archivo `05_create_admin_user.sql`
3. **Reemplaza** `'USER_UUID_AQUI'` con el UUID que copiaste
4. **Run** el script

### Paso 3: Verificar
```sql
SELECT 
    u.id,
    u.email,
    u.nombre,
    r.nombre as rol
FROM usuarios u
LEFT JOIN roles r ON u.rol_id = r.id
WHERE u.email = 'admin@automate.com';
```

Deberías ver el usuario admin creado.

---

## Credenciales de Acceso

- **Email:** `admin@automate.com`
- **Password:** `Admin123!` (o la que configuraste)

---

## Método Alternativo (Flutter App)

Si prefieres crear el usuario desde la app:

1. En la pantalla de login, usa **"Sign Up"**
2. Regístrate con email y password
3. Luego ejecuta este SQL para hacerlo admin:

```sql
UPDATE usuarios 
SET 
    rol_id = (SELECT id FROM roles WHERE nombre = 'admin'),
    tipo_perfil = 'admin'
WHERE email = 'tu-email@ejemplo.com';
```

---

## Troubleshooting

### ❌ Usuario no puede login
- Verifica que "Auto Confirm User" esté en YES
- Verifica que el usuario existe en `auth.users`
- Verifica que el usuario existe en tabla `usuarios`

### ❌ "User not found"
- El trigger `handle_new_user()` debería crear automáticamente el registro en `usuarios`
- Si no se creó, ejecuta manualmente el INSERT del `05_create_admin_user.sql`

### ❌ RLS Policy Error
- Verifica que las policies estén activas: `SELECT * FROM usuarios;` (debe funcionar)
- Las policies permiten que los usuarios vean su propio registro
