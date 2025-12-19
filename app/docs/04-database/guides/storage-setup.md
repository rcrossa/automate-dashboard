# Configuración de Supabase Storage para Logos

Esta guía te ayudará a configurar el bucket de Supabase Storage desde el Dashboard UI.

## Paso 1: Crear el Bucket

1. Ve a tu proyecto en [Supabase Dashboard](https://app.supabase.com)
2. En el menú lateral, selecciona **Storage**
3. Click en **New bucket**
4. Configuración del bucket:
   - **Name**: `company-logos`
   - **Public bucket**: **OFF** (privado - más seguro con signed URLs)
   - **File size limit**: 5 MB (recomendado)
   - **Allowed MIME types**: Dejar vacío para permitir todos los tipos de imagen
5. Click **Create bucket**

> **¿Por qué privado?** Más seguro. Las políticas RLS controlan quién puede leer/escribir.

---

## PASO 2: Crear Políticas desde la UI

### 2.1 Ir a Políticas

1. **Dashboard → Storage → company-logos**
2. Click en pestaña **"Policies"**
3. Click **"New Policy"**

### 2.2 Política 1: Lectura para Autenticados

**Opciones**:
- **Policy name**: `Usuarios autenticados pueden ver logos`
- **Allowed operation**: `SELECT`
- **Target roles**: `authenticated`

**Policy definition** (pestaña "Using SQL editor"):
```sql
bucket_id = 'company-logos' AND auth.role() = 'authenticated'
```

Click **"Review"** → **"Save policy"**

> **Seguridad**: Solo usuarios logueados pueden ver logos. Si necesitas que sean públicos (ej: en página de login), cambia a `auth.role() IN ('authenticated', 'anon')`

---

### 2.3 Política 2: Admin Puede Subir Logo

**Opciones**:
- **Policy name**: `Admin puede subir logo de su empresa`
- **Allowed operation**: `INSERT`
- **Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'company-logos' AND
auth.uid() IN (
  SELECT u.id 
  FROM public.usuarios u
  LEFT JOIN public.roles r ON u.rol_id = r.id
  WHERE (
    u.tipo_perfil IN ('admin', 'super_admin')
    OR r.nombre IN ('admin', 'super_admin')
  )
  AND (
    u.tipo_perfil = 'super_admin'
    OR u.empresa_id = (split_part(name, '/', 1))::bigint
  )
)
```

Click **"Review"** → **"Save policy"**

---

### 2.4 Política 3: Admin Puede Actualizar Logo

**Opciones**:
- **Policy name**: `Admin puede actualizar logo de su empresa`
- **Allowed operation**: `UPDATE`
- **Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'company-logos' AND
auth.uid() IN (
  SELECT u.id 
  FROM public.usuarios u
  LEFT JOIN public.roles r ON u.rol_id = r.id
  WHERE (
    u.tipo_perfil IN ('admin', 'super_admin')
    OR r.nombre IN ('admin', 'super_admin')
  )
  AND (
    u.tipo_perfil = 'super_admin'
    OR u.empresa_id = (split_part(name, '/', 1))::bigint
  )
)
```

Click **"Review"** → **"Save policy"**

---

### 2.5 Política 4: Admin Puede Borrar Logo

**Opciones**:
- **Policy name**: `Admin puede borrar logo de su empresa`
- **Allowed operation**: `DELETE`
- **Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'company-logos' AND
auth.uid() IN (
  SELECT u.id 
  FROM public.usuarios u
  LEFT JOIN public.roles r ON u.rol_id = r.id
  WHERE (
    u.tipo_perfil IN ('admin', 'super_admin')
    OR r.nombre IN ('admin', 'super_admin')
  )
  AND (
    u.tipo_perfil = 'super_admin'
    OR u.empresa_id = (split_part(name, '/', 1))::bigint
  )
)
```

Click **"Review"** → **"Save policy"**

---

## PASO 3: Verificación

1. **Storage → company-logos → Policies**
2. Deberías ver **4 políticas**:
   - ✅ Logos son públicos - lectura (SELECT)
   - ✅ Admin puede subir logo de su empresa (INSERT)
   - ✅ Admin puede actualizar logo de su empresa (UPDATE)
   - ✅ Admin puede borrar logo de su empresa (DELETE)

---

## Estructura de Paths

Los archivos se guardarán como:
```
company-logos/
  ├── 1/
  │   ├── logo_1234567890.png
  │   └── logo_light_1234567890.png
  ├── 2/
  │   └── logo_1234567890.png
  └── 3/
      └── logo_1234567890.png
```

Donde `1`, `2`, `3` son los `empresa_id`.

---

## Troubleshooting

### Error: "new row violates row-level security policy"
- Verifica que el usuario esté autenticado
- Verifica que tiene rol `admin` o `super_admin`
- Verifica que el path comience con su `empresa_id`

### Error: "The resource already exists"
- Ya existe un archivo con ese nombre
- El repository genera nombres únicos con timestamp

### Logos no se ven
- Verifica que el bucket sea **público**
- Verifica política SELECT esté creada
- Verifica URL generada sea correcta

---

## Siguiente Paso

Una vez completado el setup, avísame y continúo con:
1. Completar método `_saveBranding()` para subir logos
2. Implementar sistema de caché híbrido
3. Testing completo

**¿Todo listo?** ✅
