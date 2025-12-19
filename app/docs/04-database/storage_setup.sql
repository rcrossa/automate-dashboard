-- ========================================
-- SUPABASE STORAGE SETUP: Company Logos
-- ========================================
-- Este script configura el almacenamiento de logos de empresa
-- Ejecutar DESPUÉS del schema.sql principal
-- ========================================

-- IMPORTANTE: Este script debe ejecutarse en el SQL Editor de Supabase
-- Dashboard → Project → SQL Editor → New Query → Pegar este código

-- ========================================
-- PASO 1: Crear Bucket para Logos
-- ========================================

-- Nota: Los buckets se crean desde el Dashboard de Supabase:
-- Storage → New Bucket
-- Configuración recomendada:
--   - Name: company-logos  
--   - Public bucket: true (para acceso sin auth a logos)
--   - File size limit: 5MB
--   - Allowed MIME types: image/png, image/jpeg, image/svg+xml, image/webp

-- Si prefieres crear por SQL (requiere permisos de servicio):
-- INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
-- VALUES (
--   'company-logos',
--   'company-logos',
--   true,
--   5242880, -- 5MB en bytes
--   '{image/png,image/jpeg,image/svg+xml,image/webp}'
-- )
-- ON CONFLICT (id) DO NOTHING;

-- ========================================
-- PASO 2: Políticas RLS para Storage
-- ========================================

-- 2.1 Permitir que TODOS lean los logos (público)
CREATE POLICY "Logos son públicos - lectura"
ON storage.objects FOR SELECT
USING (bucket_id = 'company-logos');

-- 2.2 Solo admins pueden subir logos de SU empresa
-- El path debe ser: empresa_id/logo.ext
-- Por ejemplo: 123/logo.png
CREATE POLICY "Admin puede subir logo de su empresa"
ON storage.objects FOR INSERT
WITH CHECK (
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
      -- Super admin puede subir para cualquier empresa
      u.tipo_perfil = 'super_admin'
      OR
      -- Admin solo puede subir para su empresa
      -- El path es empresa_id/filename, extraemos empresa_id con split_part
      u.empresa_id = (split_part(name, '/', 1))::bigint
    )
  )
);

-- 2.3 Solo admins pueden actualizar logos de SU empresa
CREATE POLICY "Admin puede actualizar logo de su empresa"
ON storage.objects FOR UPDATE
USING (
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
      OR
      u.empresa_id = (split_part(name, '/', 1))::bigint
    )
  )
);

-- 2.4 Solo admins pueden borrar logos de SU empresa
CREATE POLICY "Admin puede borrar logo de su empresa"
ON storage.objects FOR DELETE
USING (
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
      OR
      u.empresa_id = (split_part(name, '/', 1))::bigint
    )
  )
);

-- ========================================
-- PASO 3: Habilitar RLS en Storage
-- ========================================

-- Verificar que RLS esté habilitado (normalmente ya lo está)
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- ========================================
-- VERIFICACIÓN
-- ========================================

-- Ver buckets existentes:
-- SELECT * FROM storage.buckets WHERE id = 'company-logos';

-- Ver políticas de storage:
-- SELECT * FROM pg_policies WHERE tablename = 'objects' AND policyname LIKE '%logo%';

-- ========================================
-- INSTRUCCIONES DE USO
-- ========================================

/*
CÓMO EJECUTAR ESTE SCRIPT:

1. **Crear el Bucket Manualmente** (Recomendado):
   - Ir a: Supabase Dashboard → Storage → New Bucket
   - Name: company-logos
   - Public: ✅ true
   - File size limit: 5MB
   - Allowed MIME types: image/png, image/jpeg, image/svg+xml, image/webp
   - Click "Create bucket"

2. **Ejecutar las Políticas RLS**:
   - Ir a: Supabase Dashboard → SQL Editor
   - Copiar SOLO las secciones PASO 2 y PASO 3 de este archivo
   - Pegar en el editor
   - Click "Run"

3. **Verificar**:
   - Storage → company-logos debe aparecer
   - SQL Editor → Ejecutar queries de verificación

ESTRUCTURA DE PATHS EN STORAGE:

Los archivos se guardarán como:
  company-logos/
    ├── 1/
    │   ├── logo.png
    │   ├── logo_light.png
    │   └── favicon.png
    ├── 2/
    │   └── logo.png
    └── 3/
        └── logo.png

Donde el número es el empresa_id.

LÍMITES Y RECOMENDACIONES:

- Tamaño máximo: 5MB por archivo
- Formatos: PNG, JPEG, SVG, WebP
- Resolución recomendada: 512x512px para logo principal
- Usar SVG cuando sea posible (escalable)
- Comprimir imágenes antes de subir

TROUBLESHOOTING:

Si las políticas fallan:
1. Verificar que el bucket existe
2. Verificar que RLS está habilitado
3. Verificar que el usuario tiene rol admin/super_admin
4. Verificar que empresa_id en usuarios coincide con path

Logs de errores:
- Dashboard → Logs → Storage
*/
