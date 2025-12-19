# Guía de Personalización de Marca (Theming)

## 🎨 Introducción

El sistema de theming permite a cada empresa personalizar la apariencia de la aplicación mediante la configuración de colores corporativos. Los cambios aplican automáticamente a toda la aplicación para todos los usuarios de esa empresa.

---

## 📍 Cómo Acceder

1. Iniciar sesión como **admin** de la empresa
2. Ir al **Dashboard de la Empresa**
3. En el tab **Resumen**, scroll hasta **"Configuración de la Empresa"**
4. Click en **"Personalización de Marca"**
5. Seleccionar colores y guardar

---

## 🎨 Los Tres Colores Principales

### 1️⃣ **Color Primario** (Primary Color)

**Es qué**: El color PRINCIPAL de tu empresa (ej: azul de Facebook, rojo de Coca-Cola)

**Dónde se usa**:
- Headers y AppBars
- Botones principales
- Floating Action Buttons (FAB)
- Elementos destacados
- Color de fondo de componentes importantes

**Importancia**: 
- Es la "semilla" que Material 3 usa para generar toda una paleta armoniosa
- Debe ser el color más reconocible de tu marca
- Aparece con más frecuencia en la UI

**Ejemplo**: 
- Si tu empresa es un banco, podría ser azul confianza: `#0066CC`
- Si es una marca de alimentos, podría ser verde fresco: `#4CAF50`

---

### 2️⃣ **Color Secundario** (Secondary Color)

**Es qué**: Color de APOYO que complementa al primario sin competir

**Dónde se usa**:
- Botones secundarios
- Chips y badges
- Elementos de navegación seleccionados
- Switches, checkboxes
- Fondos de tarjetas secundarias

**Importancia**:
- Agrega variedad visual sin saturar
- Debe contrastar sutilmente con el primario
- Ayuda a crear jerarquía visual

**Ejemplo**:
- Si primario es azul `#0066CC`, secundario podría ser gris oscuro `#424242`
- Si primario es naranja `#FF6B35`, secundario podría ser azul oscuro `#2C3E50`

---

### 3️⃣ **Color de Acento** (Accent/Tertiary Color)

**Es qué**: Color para DESTACAR elementos que necesitan atención especial

**Dónde se usa**:
- Alertas importantes
- Badges de notificaciones
- Elementos de acción urgente
- CTAs (Call To Action) especiales
- Elementos que requieren interacción inmediata

**Importancia**:
- Llama la atención sin abrumar
- Debe ser vibrante pero no excesivo
- Úsalo con moderación para máximo impacto

**Ejemplo**:
- Si los colores principales son fríos (azules), acento podría ser cálido (naranja) `#FF6B35`
- Para alertas de error: rojo `#F44336`
- Para confirmaciones: verde `#4CAF50`

---

## 🔧 Cómo Funciona Técnicamente

Cuando configuras tus tres colores, el sistema hace lo siguiente:

```dart
ColorScheme.fromSeed(
  seedColor: primaryColor,      // Tu color primario
  secondary: secondaryColor,     // Tu color secundario  
  tertiary: accentColor,         // Tu color de acento
  brightness: isDark ? Brightness.dark : Brightness.light,
)
```

**Material 3 automáticamente**:
1. ✅ Genera ~40 variantes de colores (light, dark, container, etc.)
2. ✅ Calcula colores de texto con buen contraste
3. ✅ Crea una paleta armoniosa
4. ✅ Asegura accesibilidad WCAG
5. ✅ Adapta al modo oscuro/claro

---

## 🎯 Ejemplos de Paletas Exitosas

### Paleta Corporativa (Banco/Finanzas)
```
Primary:   #0066CC  (Azul confianza)
Secondary: #424242  (Gris profesional)
Accent:    #FF6B35  (Naranja acción)
```

### Paleta Salud/Bienestar
```
Primary:   #4CAF50  (Verde salud)
Secondary: #81C784  (Verde claro)
Accent:    #FFA726  (Naranja energía)
```

### Paleta Tecnología/Innovación
```
Primary:   #3F51B5  (Índigo tech)
Secondary: #FF4081  (Pink moderno)
Accent:    #00BCD4  (Cyan innovación)
```

### Paleta Educación
```
Primary:   #2196F3  (Azul educativo)
Secondary: #FFC107  (Amarillo creatividad)
Accent:    #4CAF50  (Verde crecimiento)
```

---

## ❌ Errores Comunes a Evitar

### 1. **Tres Colores Muy Saturados**
```
❌ MAL:
Primary:   #FF0000  (Rojo puro)
Secondary: #00FF00  (Verde puro)
Accent:    #0000FF  (Azul puro)
```
**Por qué es malo**: Visual caos, cansa la vista, no profesional

---

### 2. **Colores Muy Similares**
```
❌ MAL:
Primary:   #2196F3  (Azul)
Secondary: #1976D2  (Azul ligeramente más oscuro)
Accent:    #42A5F5  (Azul ligeramente más claro)
```
**Por qué es malo**: No se distinguen elementos, confunde al usuario

---

### 3. **Primario Muy Claro**
```
❌ MAL:
Primary:   #E3F2FD  (Azul muy claro)
```
**Por qué es malo**: Mal contraste con texto blanco, ilegible

---

### 4. **Ignorar el Contraste**
```
❌ MAL:
Primary:   #FFEB3B  (Amarillo brillante)
Secondary: #FFFF00  (Amarillo más brillante)
```
**Por qué es malo**: Texto oscuro ilegible sobre amarillo claro

---

## ✅ Mejores Prácticas

### 1. **Regla 60-30-10**
- **60%** del espacio visual: Color primario (+ sus variantes)
- **30%** del espacio visual: Color secundario
- **10%** del espacio visual: Color de acento

### 2. **Contraste Suficiente**
- Ratio mínimo de contraste: **4.5:1** para texto normal
- Ratio mínimo de contraste: **3:1** para texto grande
- Usa herramientas: [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

### 3. **Probá en Modo Oscuro**
- Activá el dark mode y verificá que los colores se vean bien
- El sistema ajusta automáticamente, pero siempre probá

### 4. **Mantené Consistencia**
- Usá colores de tu logo/marca corporativa
- Si tenés brand guidelines, seguí esas especificaciones

---

## 🛠️ Herramientas Útiles

### Generadores de Paletas
- [Coolors.co](https://coolors.co/) - Generador de paletas
- [Adobe Color](https://color.adobe.com/) - Rueda de colores
- [Material Design Color Tool](https://m2.material.io/resources/color/) - Específico para Material Design

### Verificadores de Accesibilidad
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Contrast Ratio](https://contrast-ratio.com/)

### Inspiración
- [Material Design Color System](https://m3.material.io/styles/color/system/overview)
- [Dribbble Color Palettes](https://dribbble.com/colors/)

---

## 📱 Vista Previa

Para ver tus cambios:
1. Guardá la configuración
2. La app se recarga automáticamente
3. Navegá por diferentes pantallas para ver cómo se aplican los colores
4. Si no te gusta, volvé a cambiarlos - es reversible

---

## 🔒 Seguridad y Permisos

- Solo **admins de empresa** pueden cambiar el branding
- Los cambios aplican **solo a su empresa** (multi-tenant)
- Los usuarios regulares ven el tema pero no pueden modificarlo
- Super admins ven el tema por defecto

---

## 💾 Dónde se Guardan los Datos

Los colores se almacenan en la tabla `empresa_branding`:

```sql
CREATE TABLE empresa_branding (
    id SERIAL PRIMARY KEY,
    empresa_id BIGINT REFERENCES empresas(id),
    color_primario TEXT NOT NULL,      -- Hex: #0066CC
    color_secundario TEXT NOT NULL,    -- Hex: #424242
    color_acento TEXT NOT NULL,        -- Hex: #FF6B35
    -- ... otros campos
);
```

---

## 🐛 Troubleshooting

### Problema: "Los colores no se ven"
**Solución**: Hacé logout y login nuevamente, o recargá la app

### Problema: "El texto no se lee bien"
**Solución**: El sistema usa Material 3 para generar texto con buen contraste automáticamente. Si persiste, elegí colores menos saturados.

### Problema: "Quiero volver al tema por defecto"
**Solución**: Configurá los colores:
- Primary: `#2196F3`
- Secondary: `#424242`
- Accent: `#FF6B35`

---

## 📞 Soporte

Si tenés problemas con el theming, contactá al equipo de desarrollo con:
- Capturas de pantalla
- Colores hex que estás usando
- Descripción del problema

---

## 📚 Referencias

- [Material Design 3 - Color System](https://m3.material.io/styles/color/system/overview)
- [Flutter ThemeData Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
- [ColorScheme.fromSeed](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html)
