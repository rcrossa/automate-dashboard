# Sistema de Theming Multi-Tenant

## 📋 Descripción General

Sistema que permite a cada empresa personalizar la apariencia visual de la aplicación con sus propios colores, logo y tipografía, creando una experiencia de marca única para cada tenant.

---

## 🎯 Objetivo

Permitir **white-labeling** donde cada empresa ve la aplicación con:
- ✅ Sus colores corporativos
- ✅ Su logo
- ✅ Su tipografía preferida
- ✅ Modo oscuro personalizado (opcional)

---

## 🏗️ Arquitectura

### Base de Datos

**Tabla**: `empresa_branding`

```sql
empresa_branding (
  id SERIAL PRIMARY KEY,
  empresa_id INTEGER UNIQUE,  -- Una configuración por empresa
  
  -- Colores base (Material Design)
  color_primario VARCHAR(7),    -- Color principal (#RRGGBB)
  color_secundario VARCHAR(7),  -- Color secundario
  color_acento VARCHAR(7),      -- Color de acento
  
  -- Assets
  logo_url TEXT,               -- Logo principal
  logo_light_url TEXT,         -- Logo para dark mode
  favicon_url TEXT,            -- Favicon/App icon
  
  -- Tipografía
  fuente_primaria VARCHAR(50), -- Ej: 'Roboto', 'Inter'
  
  -- Dark Mode
  dark_mode_habilitado BOOLEAN,
  color_primario_dark VARCHAR(7),
  color_secundario_dark VARCHAR(7),
  
  -- Timestamps
  fecha_creacion TIMESTAMP,
  actualizado_en TIMESTAMP
)
```

**Valores por Defecto**:
- Color primario: `#1976D2` (Azul Material)
- Color secundario: `#DC004E` (Rosa Material)
- Color acento: `#FFC107` (Ámbar)
- Fuente: `Roboto`

**Seguridad RLS**:
- Admins pueden editar branding de su empresa
- Usuarios pueden ver branding de su empresa
- Super admins pueden gestionar todas

---

## 📦 Estructura de Código

### 1. Entidad
```
lib/domain/entities/empresa_branding.dart
```
Modelo de datos con helpers para convertir hex a Color y generar ThemeData.

### 2. Repository
```
lib/domain/repositories/branding_repository.dart  (interface)
lib/data/repositories/supabase_branding_repository.dart  (implementación)
```
Gestiona operaciones CRUD de branding y upload de logos.

### 3. Providers
```
lib/presentation/providers/branding_provider.dart
lib/presentation/providers/theme_provider.dart
```
Provee branding y theme dinámico a toda la app.

### 4. UI
```
lib/presentation/screens/admin/branding_settings_screen.dart
```
Pantalla para configurar branding (solo admins).

---

## 🎨 Colores: Diseño de 3 Columnas

### Decisión de Diseño

Usamos **3 columnas fijas** para colores base:
- `color_primario`
- `color_secundario`
- `color_acento`

### ¿Por qué 3 colores?

1. **Material Design estándar** usa estos 3
2. **Suficiente para 90% de casos**
3. **Simple y validable** con tipos SQL
4. **Fácil de consultar** sin joins complejos

### Agregar Más Colores en el Futuro

**Opción A: Nueva Migration** (para colores permanentes)
```sql
ALTER TABLE empresa_branding 
ADD COLUMN color_superficie VARCHAR(7) DEFAULT '#FFFFFF';
```

**Opción B: Campo JSONB** (para colores extras opcionales)
```sql
ALTER TABLE empresa_branding 
ADD COLUMN colores_extras JSONB DEFAULT '{}'::jsonb;
```

Uso en código:
```dart
// Colores base (siempre disponibles)
final primary = branding.colorPrimario;

// Colores extras (opcionales)
final surface = branding.coloresExtras?['superficie'] ?? '#FFFFFF';
final success = branding.coloresExtras?['exito'] ?? '#4CAF50';
```

**Recomendación**: Empezar con 3 columnas, agregar `colores_extras JSONB` solo si se necesita.

---

## 🔄 Flujo de Datos

```
Usuario cambia color en UI
    ↓
BrandingSettingsScreen actualiza
    ↓
BrandingRepository guarda en Supabase
    ↓
CompanyBrandingProvider se actualiza
    ↓
AppThemeProvider regenera ThemeData
    ↓
MaterialApp aplica nuevo theme
    ↓
UI se redibuja con nuevos colores
```

---

## 💻 Uso del Sistema

### Cargar Theme Dinámico

```dart
// main.dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);
    final theme = ref.watch(appThemeProvider(isDark: isDark));
    
    return MaterialApp(
      theme: theme,  // ✅ Theme dinámico según empresa
      home: PantallaPrincipal(),
    );
  }
}
```

### Acceder a Branding

```dart
// En cualquier widget
final branding = ref.watch(companyBrandingProvider).value;

if (branding != null) {
  // Usar logo
  Image.network(branding.logoUrl ?? defaultLogo);
  
  // Usar colores personalizados
  Container(color: branding.primaryColor);
}
```

### Configurar Branding (Admin)

```dart
// Navegar a settings
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BrandingSettingsScreen(),
  ),
);

// En BrandingSettingsScreen:
// - Color pickers para cada color
// - Image picker para logo
// - Font selector
// - Preview en tiempo real
```

---

## 📁 Migraciones SQL

### Archivos de Migration

```
supabase/migrations/
  └── 20251212_add_empresa_branding.sql   ✅ Crear tabla
  └── 20251213_add_colores_extras.sql     ⏳ Futuro (si se necesita)
```

### Ejecutar Migration

```bash
# Opción 1: Supabase CLI
supabase db push

# Opción 2: Dashboard Supabase
# SQL Editor → Copiar SQL → Run
```

### Rollback (si es necesario)

```sql
DROP TABLE IF EXISTS empresa_branding CASCADE;
```

---

## 🎨 Theming Avanzado (Futuro)

### Extensiones Posibles

1. **Más Colores**
   - Error, Warning, Success, Info
   - Surface, Background variations
   - Usar campo JSONB `colores_extras`

2. **Gradientes**
   ```sql
   gradiente_config JSONB DEFAULT '{
     "tipo": "linear",
     "colores": ["#1976D2", "#64B5F6"],
     "direccion": "toRight"
   }'
   ```

3. **Bordes/Sombras**
   ```sql
   border_radius INTEGER DEFAULT 4,
   elevation_level INTEGER DEFAULT 2
   ```

4. **Tipografías Múltiples**
   ```sql
   fuente_titulos VARCHAR(50),
   fuente_cuerpo VARCHAR(50),
   fuente_codigo VARCHAR(50)
   ```

5. **Logo Variations**
   ```sql
   logo_sm_url TEXT,  -- Logo pequeño
   logo_md_url TEXT,  -- Logo mediano
   logo_lg_url TEXT   -- Logo grande
   ```

---

## 🔒 Seguridad

### Validaciones

**SQL Level**:
- Formato hex válido: `#[0-9A-Fa-f]{6}`
- Constraint check en migration

**Dart Level**:
```dart
bool isValidHexColor(String color) {
  return RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(color);
}
```

### Storage

**Logos en Supabase Storage**:
- Bucket: `company-logos`
- Path: `{empresa_id}/logo.png`
- Max size: 2MB
- Formatos: PNG, WEBP, SVG

**Políticas de Storage**:
```sql
-- Solo admins pueden subir
CREATE POLICY "Admins can upload logos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'company-logos'
  AND (storage.foldername(name))[1]::int IN (
    SELECT empresa_id FROM usuarios 
    WHERE auth.uid() = id AND rol = 'admin'
  )
);
```

---

## 📊 Casos de Uso

### Caso 1: Empresa Nueva (Onboarding)

1. Admin crea cuenta
2. Sistema crea `empresa_branding` con defaults
3. Admin personaliza colores en Settings
4. Sube logo
5. ✅ App muestra branding personalizado

### Caso 2: Cambio de Marca

1. Admin navega a Branding Settings
2. Cambia color primario
3. Preview muestra cambios en tiempo real
4. Guarda
5. ✅ Toda la app se actualiza inmediatamente

### Caso 3: Múltiples Empresas

1. Usuario pertenece a Empresa A (azul)
2. Inicia sesión → Ve app azul
3. Cambia a Empresa B (roja)
4. ✅ App cambia a tema rojo automáticamente

---

## 🧪 Testing

### Unit Tests
```dart
test('EmpresaBranding converts hex to Color', () {
  final branding = EmpresaBranding(colorPrimario: '#1976D2');
  expect(branding.primaryColor, Color(0xFF1976D2));
});
```

### Widget Tests
```dart
testWidgets('App uses company theme', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        companyBrandingProvider.overrideWith(
          () => FakeBranding(colorPrimario: '#FF0000')
        ),
      ],
      child: MyApp(),
    ),
  );
  
  final theme = Theme.of(tester.element(find.byType(MaterialApp)));
  expect(theme.primaryColor, Color(0xFFFF0000));
});
```

---

## 📝 Notas de Implementación

### Decisiones Técnicas

1. **3 colores fijos vs JSONB flexible**
   - Decidimos: 3 colores fijos
   - Razón: Simplicidad, validación, suficiente para MVP
   - Extensible: Agregar JSONB después si se necesita

2. **Storage vs Base64**
   - Decidimos: Supabase Storage URLs
   - Razón: No infla la DB, cacheable, CDN

3. **Provider vs GetX vs Bloc**
   - Decidimos: Riverpod
   - Razón: Ya usado en el proyecto, reactivo

4. **Theme hot-reload**
   - Sí: Provider reactive permite cambios en vivo
   - No requiere restart de app

---

## 🚀 Roadmap

### MVP (Básico) - 4-6 horas ✅
- [x] Schema SQL
- [ ] Modelo + Repository
- [ ] Provider de theme
- [ ] Settings básico (color picker)
- [ ] Integración en MaterialApp

### v1.1 (Logo) - 2 horas
- [ ] Logo upload
- [ ] Logo display en AppBar
- [ ] Logo en login screen

### v1.2 (Advanced) - 1 semana
- [ ] Dark mode personalizado
- [ ] Preview en tiempo real mejorado
- [ ] Theme presets
- [ ] Font selector

### v2.0 (Full Branding) - 2 semanas
- [ ] Email templates con branding
- [ ] PDF exports con branding
- [ ] Subdomain personalizado
- [ ] Custom domain support

---

## 📚 Referencias

- [Material Design Color System](https://m3.material.io/styles/color/overview)
- [Flutter Theming Guide](https://docs.flutter.dev/cookbook/design/themes)
- [Supabase Storage](https://supabase.com/docs/guides/storage)
- [Riverpod Providers](https://riverpod.dev/)

---

## 🔧 Mantenimiento

### Actualizar Colores Default

```sql
UPDATE empresa_branding 
SET color_primario = '#NEW_COLOR'
WHERE empresa_id = 1;
```

### Migrar Empresa a Nuevos Defaults

```sql
-- Reset a defaults
UPDATE empresa_branding
SET 
  color_primario = '#1976D2',
  color_secundario = '#DC004E',
  color_acento = '#FFC107'
WHERE empresa_id = 1;
```

### Backup de Branding

```sql
-- Exportar configuraciones
COPY (
  SELECT * FROM empresa_branding
) TO '/tmp/branding_backup.csv' CSV HEADER;
```

---

**Última actualización**: 2025-12-12  
**Autor**: Sistema de Theming Multi-Tenant  
**Versión**: 1.0 (MVP en desarrollo)
