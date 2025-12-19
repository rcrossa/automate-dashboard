# Guía de Desarrollo para Nuevos Integrantes

¡Bienvenido al equipo! Esta guía está diseñada para ayudarte a entender rápidamente cómo trabajamos, la arquitectura del proyecto y cómo implementar nuevas funcionalidades siguiendo nuestros estándares.

## 1. Filosofía del Proyecto
Nuestro objetivo es construir una aplicación escalable, mantenible y robusta. Para ello, seguimos estos principios:

- **Clean Architecture (Simplificada)**: Separamos la UI, la lógica de negocio (Servicios) y los datos (Modelos/DTOs).
- **Inmutabilidad**: Preferimos objetos inmutables y gestión de estado predecible.
- **Explicit Dependencies**: Evitamos variables globales mágicas. Las dependencias (como `empresaId`) se pasan explícitamente.
- **Fail Fast & Gracefully**: Manejamos los errores en la capa de servicio y mostramos feedback claro al usuario.

## 2. Stack Tecnológico
- **Frontend**: Flutter (Dart).
- **Backend**: Supabase (PostgreSQL + Auth + Storage).
- **Estado**: Riverpod (Hooks & Code Generation).
- **L10n**: `flutter_localizations` (Archivos ARB).

## 3. Estructura del Código
¿Dónde encuentro qué?

- `lib/core/`: Utilidades base y manejo de errores (`Failure`).
- `lib/models/`: Clases de datos (DTOs) con `fromJson`/`toJson`.
- `lib/providers/`: Estado global (`user_provider.dart`, etc.).
- `lib/services/`: Lógica de negocio y llamadas a Supabase.
- `lib/screens/`: Pantallas organizadas por módulo (`admin`, `company`, `user`).
- `lib/widgets/`: Componentes reutilizables.
- `lib/l10n/`: Archivos de traducción.

## 4. Flujo de Trabajo: Nueva Funcionalidad
Pasos recomendados para añadir una feature:

1.  **Base de Datos**: Si requiere persistencia, crea/modifica la tabla en Supabase y actualiza `schema.sql`.
2.  **Modelo**: Crea la clase en `lib/models/` (ej. `Producto.dart`).
3.  **Servicio**: Crea `lib/services/producto_service.dart`.
    - Implementa métodos CRUD.
    - **Importante**: Envuelve llamadas a Supabase en `try-catch` y lanza `ServerFailure`.
4.  **UI**: Crea la pantalla en `lib/screens/`.
    - Usa `ConsumerWidget` si necesitas acceder al estado (`ref`).
    - Usa `AppLocalizations` para todos los textos.
5.  **Estado (Opcional)**: Si la data es compleja o compartida, crea un Provider.

## 5. Gestión de Estado con Riverpod
Usamos `flutter_riverpod` para la gestión de estado. Es vital entender los conceptos básicos:

### Conceptos Clave
- **Provider**: Objeto inmutable que expone un valor.
- **ConsumerWidget**: Widget que puede "escuchar" (watch) providers.
- **Ref**: Objeto que permite interactuar con los providers (leer, escuchar).

### Guía Rápida (Cookbook)

#### 1. Crear un Provider (Estado Simple)
```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

#### 2. Leer un valor en la UI (build)
Usa `ref.watch` para reconstruir el widget cuando el valor cambie.
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

#### 3. Modificar el estado (Eventos)
Usa `ref.read` dentro de callbacks (onPressed, etc). **Nunca uses ref.watch dentro de callbacks**.
```dart
ElevatedButton(
  onPressed: () => ref.read(counterProvider.notifier).state++,
  child: Text('Incrementar'),
);
```

#### 4. Acceder a la Sesión del Usuario
Tenemos un provider global `userStateProvider` que contiene la sesión actual.
```dart
final userState = ref.watch(userStateProvider);
final usuario = userState.asData?.value; // Acceder al objeto UserSession
final empresa = usuario?.empresa;
```

## 6. Manejo de Errores
No lances `Exception` genéricas. Usa las clases definidas en `lib/core/error/failure.dart`:

```dart
try {
  // llamada a supabase
} on PostgrestException catch (e) {
  throw ServerFailure(e.message);
} catch (e) {
  throw ServerFailure(e.toString());
}
```

En la UI, captura estos errores y muestra un `SnackBar` o diálogo amigable.

## 7. Internacionalización (l10n)
Nunca escribas textos "hardcoded" en los widgets.
1.  Agrega la clave en `lib/l10n/app_es.arb` y `app_en.arb`.
2.  Ejecuta `flutter gen-l10n` (o guarda si tienes hot-reload configurado).
3.  Usa `AppLocalizations.of(context)!.miClave`.

## 8. Git & Versionado
- Commits descriptivos.
- Ramas por feature (`feature/nueva-funcionalidad`).
- Code Review antes de mergear a `main`.

## 9. Documentación del Proyecto
Mantenemos la documentación viva dentro del repositorio:

- **`docs/guia_desarrollo.md`**: (Este archivo) Guía de inicio rápido y estándares.
- **`docs/arquitectura_flutter.md`**: Detalles técnicos profundos sobre la arquitectura, estructura de carpetas y decisiones de diseño.
- **`docs/database/schema.sql`**: La fuente de la verdad para la estructura de la base de datos.
- **`docs/database/`**: Scripts de migración y utilidades SQL.

---
*Si tienes dudas, consulta `docs/arquitectura_flutter.md` para detalles más técnicos.*
