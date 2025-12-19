# Guía Técnica: Responsive Design

**Versión**: 1.0  
**Fecha**: 13 de diciembre de 2025  
**Autor**: Equipo de Desarrollo

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura](#arquitectura)
3. [ResponsiveHelper](#responsivehelper)
4. [Breakpoints](#breakpoints)
5. [Implementación](#implementación)
6. [Ejemplos de Uso](#ejemplos-de-uso)
7. [Best Practices](#best-practices)
8. [Testing](#testing)
9. [Troubleshooting](#troubleshooting)

---

## Introducción

Esta aplicación Flutter utiliza un sistema de diseño responsive basado en **Material Design** para proporcionar experiencias de usuario optimizadas en dispositivos móviles, tablets y desktops.

### Objetivos

- ✅ **Consistencia**: Breakpoints estandarizados en toda la aplicación
- ✅ **Mantenibilidad**: Lógica centralizada en un único helper
- ✅ **Escalabilidad**: Fácil adaptación de nuevas pantallas
- ✅ **UX**: Experiencia óptima en cada tamaño de dispositivo

### Cobertura

**Pantallas responsive**: 9  
**Dialogs responsive**: 3  
**Tests**: 7 tests unitarios del helper

---

## Arquitectura

### Estructura

```
lib/
├── utils/
│   └── responsive_helper.dart      # ⭐ Helper centralizado
├── presentation/
│   ├── screens/
│   │   ├── company/
│   │   │   ├── company_dashboard_screen.dart
│   │   │   ├── marketplace_screen.dart
│   │   │   └── widgets/
│   │   │       ├── company_mobile_layout.dart
│   │   │       └── company_desktop_layout.dart
│   │   ├── auth/
│   │   │   └── login_pantalla.dart
│   │   ├── client/
│   │   │   ├── client_list_screen.dart
│   │   │   └── client_detail_screen.dart
│   │   └── crm/
│   │       └── claims/
│   │           └── claims_list_screen.dart
test/
└── utils/
    └── responsive_helper_test.dart  # Tests del helper
```

### Principios de Diseño

1. **Mobile First**: El diseño base es para móvil
2. **Progressive Enhancement**: Mejoras progresivas para pantallas más grandes
3. **Content Reflow**: El contenido se reorganiza según el espacio disponible
4. **Single Source of Truth**: `ResponsiveHelper` es la única fuente de verdad

---

## ResponsiveHelper

### Ubicación

```dart
import 'package:msasb_app/utils/responsive_helper.dart';
```

### Métodos Disponibles

#### 1. `isMobile(BuildContext context) → bool`

Detecta si el dispositivo es móvil (< 600px).

```dart
if (ResponsiveHelper.isMobile(context)) {
  return ListView(...);
} else {
  return GridView(...);
}
```

#### 2. `isTablet(BuildContext context) → bool`

Detecta si el dispositivo es tablet (600px - 1200px).

```dart
if (ResponsiveHelper.isTablet(context)) {
  return GridView(crossAxisCount: 3, ...);
}
```

#### 3. `isDesktop(BuildContext context) → bool`

Detecta si el dispositivo es desktop (≥ 1200px).

```dart
if (ResponsiveHelper.isDesktop(context)) {
  return Row(
    children: [
      Sidebar(...),
      Expanded(child: Content(...)),
    ],
  );
}
```

#### 4. `getResponsivePadding(BuildContext context) → double`

Retorna padding adaptado al tamaño de pantalla.

```dart
padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context))
```

**Valores**:
- Mobile: 16px
- Tablet: 24px
- Desktop: 32px

#### 5. `getGridCrossAxisCount(BuildContext context) → int`

Retorna número de columnas para grids.

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
  ),
  ...
)
```

**Valores**:
- Mobile: 2 columnas
- Tablet: 3 columnas
- Desktop: 4 columnas

#### 6. `getMaxContentWidth(BuildContext context) → double`

Retorna ancho máximo para contenido (previene líneas de texto muy largas).

```dart
Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: ResponsiveHelper.getMaxContentWidth(context),
    ),
    child: Content(...),
  ),
)
```

**Valores**:
- Mobile: sin límite (double.infinity)
- Tablet/Desktop: 1200px

---

## Breakpoints

Basados en **Material Design Guidelines**:

| Dispositivo | Rango de Ancho | Breakpoint | Uso Común |
|-------------|---------------|------------|-----------|
| **Mobile** | < 600px | `MOBILE_BREAKPOINT` | Teléfonos |
| **Tablet** | 600px - 1200px | `TABLET_BREAKPOINT` | Tablets, iPads |
| **Desktop** | ≥ 1200px | `DESKTOP_BREAKPOINT` | Laptops, monitores |

### ¿Por qué estos valores?

- **600px**: Transición típica de portrait móvil a tablet
- **1200px**: Transición de tablet landscape a desktop

Estos valores son estándar en Material Design y usados por Google en sus aplicaciones.

---

## Implementación

### Patrón Básico

```dart
import 'package:msasb_app/utils/responsive_helper.dart';

class MyResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return _buildMobileLayout();
    } else if (ResponsiveHelper.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }
  
  Widget _buildMobileLayout() {
    return ListView(...); // Layout vertical
  }
  
  Widget _buildTabletLayout() {
    return GridView(crossAxisCount: 3, ...); // Grid 3 columnas
  }
  
  Widget _buildDesktopLayout() {
    return Row(...); // Layout horizontal con sidebar
  }
}
```

### Patrón con LayoutBuilder

Para casos más complejos:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (ResponsiveHelper.isDesktop(context)) {
      return DesktopLayout(...);
    } else {
      return MobileLayout(...);
    }
  },
)
```

---

## Ejemplos de Uso

### Ejemplo 1: Lista Responsive

```dart
// client_list_screen.dart
Widget _buildClientsList() {
  if (ResponsiveHelper.isMobile(context)) {
    return _buildMobileList(); // ListView
  } else {
    return _buildDesktopGrid(); // GridView
  }
}

Widget _buildMobileList() {
  return ListView.builder(
    itemCount: clients.length,
    itemBuilder: (context, index) {
      return ClientCard(client: clients[index]);
    },
  );
}

Widget _buildDesktopGrid() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    itemCount: clients.length,
    itemBuilder: (context, index) {
      return ClientCard(client: clients[index]);
    },
  );
}
```

### Ejemplo 2: Dialog Responsive

```dart
// create_company_dialog.dart
@override
Widget build(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getMaxContentWidth(context),
      ),
      child: AlertDialog(
        title: Text('Crear Empresa'),
        content: Form(...),
        actions: [...],
      ),
    ),
  );
}
```

### Ejemplo 3: Dashboard con Layouts Diferentes

```dart
// company_dashboard_screen.dart
return LayoutBuilder(
  builder: (context, constraints) {
    if (ResponsiveHelper.isDesktop(context)) {
      // Desktop: Sidebar + Content
      return CompanyDesktopLayout(
        empresa: empresa,
        tabs: tabs,
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      );
    } else {
      // Mobile/Tablet: AppBar con Tabs
      return CompanyMobileLayout(
        empresa: empresa,
        tabController: _tabController,
        tabs: tabs,
      );
    }
  },
);
```

### Ejemplo 4: Tabs Scrollables en Móvil

```dart
// company_mobile_layout.dart
bottom: TabBar(
  controller: tabController,
  isScrollable: true, // Permite scroll horizontal
  tabAlignment: TabAlignment.start,
  tabs: tabs,
),
```

---

## Best Practices

### ✅ Do's

1. **Usa siempre ResponsiveHelper**
   ```dart
   // ✅ Correcto
   if (ResponsiveHelper.isMobile(context)) { ... }
   
   // ❌ Incorrecto
   if (MediaQuery.of(context).size.width < 600) { ... }
   ```

2. **Mantén los breakpoints consistentes**
   - No uses valores hardcodeados diferentes

3. **Diseña Mobile First**
   ```dart
   // ✅ Correcto: Mobile por defecto
   return ResponsiveHelper.isMobile(context)
       ? MobileLayout()
       : DesktopLayout();
   ```

4. **Utiliza padding responsive**
   ```dart
   padding: EdgeInsets.all(
     ResponsiveHelper.getResponsivePadding(context)
   )
   ```

5. **Limita ancho de contenido en desktop**
   ```dart
   ConstrainedBox(
     constraints: BoxConstraints(
       maxWidth: ResponsiveHelper.getMaxContentWidth(context),
     ),
     child: content,
   )
   ```

### ❌ Don'ts

1. **No uses MediaQuery directamente para breakpoints**
   ```dart
   // ❌ Evitar
   final width = MediaQuery.of(context).size.width;
   if (width > 800) { ... }
   ```

2. **No hardcodees tamaños de grid**
   ```dart
   // ❌ Evitar
   GridView(crossAxisCount: 3, ...)
   
   // ✅ Usar
   GridView(
     crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
     ...
   )
   ```

3. **No olvides mobile en tus diseños**
   - Siempre prueba en dispositivos móviles primero

4. **No uses demasiados breakpoints custom**
   - Mantente con Mobile, Tablet, Desktop

---

## Testing

### Tests Unitarios

El `ResponsiveHelper` tiene cobertura completa de tests:

```bash
flutter test test/utils/responsive_helper_test.dart
```

**Cobertura**:
- ✅ Detección de mobile (< 600px)
- ✅ Detección de tablet (600-1200px)
- ✅ Detección de desktop (≥ 1200px)
- ✅ Padding responsive
- ✅ Grid columns
- ✅ Max width

### Testing Manual

1. **Usa Device Preview** (recomendado):
   ```yaml
   dependencies:
     device_preview: ^1.1.0
   ```

2. **Usa Flutter DevTools** para cambiar tamaños de ventana

3. **Prueba en dispositivos reales**:
   - iPhone (móvil pequeño)
   - iPad (tablet)
   - macOS/Windows (desktop)

### Comandos Útiles

```bash
# Ejecutar en diferentes dispositivos
flutter run -d chrome --web-browser-flag="--window-size=375,812"  # iPhone
flutter run -d chrome --web-browser-flag="--window-size=768,1024" # iPad
flutter run -d chrome --web-browser-flag="--window-size=1920,1080" # Desktop

# Ejecutar en macOS con tamaño específico
flutter run -d macos --window-size=800x600
```

---

## Troubleshooting

### Problema: Los breakpoints no funcionan

**Síntoma**: El layout no cambia en diferentes tamaños.

**Solución**:
1. Verifica que estés usando `ResponsiveHelper` correctamente
2. Asegúrate de tener `BuildContext` disponible
3. Usa `LayoutBuilder` si necesitas reconstruir en cambios de tamaño

### Problema: Overflow en móvil

**Síntoma**: `RenderFlex overflowed` en móvil.

**Solución**:
1. Usa `SingleChildScrollView` para contenido largo
2. Verifica que no uses width/height fijos grandes
3. Usa `Expanded` y `Flexible` apropiadamente

### Problema: Grid se ve mal en tablet

**Síntoma**: Las columnas no se adaptan bien en tablet.

**Solución**:
1. Verifica que uses `getGridCrossAxisCount()`
2. Ajusta `childAspectRatio` si es necesario
3. Considera un layout diferente para tablet

### Problema: Texto se corta en tabs móviles

**Síntoma**: Los nombres de tabs aparecen cortados.

**Solución**:
```dart
TabBar(
  isScrollable: true, // ✅ Agrega esto
  tabs: [...],
)
```

---

## Referencias

- [Material Design - Responsive Layout Grid](https://m3.material.io/foundations/layout/applying-layout/window-size-classes)
- [Flutter Responsive Design](https://docs.flutter.dev/ui/layout/responsive)
- [ResponsiveHelper Source Code](file:///Users/robertorossa/Desktop/Desarrollo/flutter/mi_primera_app/lib/utils/responsive_helper.dart)

---

## Changelog

### v1.0 - 2025-12-13
- ✅ Implementación inicial de ResponsiveHelper
- ✅ 9 pantallas refactorizadas
- ✅ 3 dialogs con max width
- ✅ Tests unitarios completos
- ✅ Documentación creada
