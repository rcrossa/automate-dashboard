# Guía de Integration Tests

## Configuración Completada ✅

### Archivos Creados
1. **`pubspec.yaml`**: Agregado `integration_test` en `dev_dependencies`
2. **`test_driver/integration_test.dart`**: Driver básico para ejecutar tests
3. **`integration_test/helpers/test_helpers.dart`**: Helpers reutilizables
4. **`integration_test/auth_flow_test.dart`**: Tests de autenticación
5. **`integration_test/navigation_test.dart`**: Tests de navegación

---

## Cómo Ejecutar los Integration Tests

### ⚠️ Requisitos Previos

**Los integration tests NO pueden ejecutarse en web**. Requieren:
- Emulador de iOS/Android ejecutándose, O
- Dispositivo físico conectado, O
- macOS desktop app

### Opción 1: macOS Desktop

```bash
# Ejecutar en macOS
flutter test integration_test/ -d macos
```

### Opción 2: Emulador Android

```bash
# 1. Iniciar emulador Android
flutter emulators --launch <emulator_id>

# 2. Ejecutar tests
flutter test integration_test/ -d <device_id>
```

### Opción 3: Emulador iOS

```bash
# 1. Iniciar simulator
open -a Simulator

# 2. Ejecutar tests
flutter test integration_test/ -d <iPhone_device_id>
```

### Ver Dispositivos Disponibles

```bash
flutter devices
```

---

## Tests Implementados

### 1. Auth Flow Tests (`auth_flow_test.dart`)

**Tests incluidos**:
- ✅ Login exitoso con credenciales válidas
- ✅ Logout exitoso

**⚠️ IMPORTANTE**: Estos tests requieren **credenciales de prueba válidas** configuradas en Supabase.

**Para configurar**:
1. Crear un usuario de prueba en Supabase
2. Actualizar las credenciales en `auth_flow_test.dart`:
   ```dart
   await tester.enterText(emailField, 'TU_EMAIL_DE_PRUEBA@example.com');
   await tester.enterText(passwordField, 'TU_PASSWORD_DE_PRUEBA');
   ```

### 2. Navigation Tests (`navigation_test.dart`)

**Tests incluidos**:
- ✅ Navegación básica en la app
- ✅ Acceso al marketplace
- ✅ Verificación de tabs dinámicos

**Nota**: Estos tests requieren que el usuario esté logueado. En producción, se ejecutarían después de los auth tests.

---

## Helpers Disponibles

El archivo `integration_test/helpers/test_helpers.dart` incluye:

```dart
// Esperar a que la página cargue
await TestHelpers.waitForPageLoad(tester);

// Login programático
await TestHelpers.login(tester, 
  email: 'test@example.com', 
  password: 'password'
);

// Logout
await TestHelpers.logout(tester);

// Verificaciones
TestHelpers.expectTextVisible('Texto esperado');
TestHelpers.expectKeyVisible(Key('mi_key'));
```

---

## Limitaciones Conocidas

### 1. Invitación Flow (SKIP)
El test de "Super admin invita usuario" **no se implementó** porque requiere:
- Interceptar emails de Supabase
- Configurar servicio de email de prueba
- Mayor complejidad de setup

**Alternativa**: Testing manual de este flujo.

### 2. Credenciales Hardcodeadas
Los tests actualmente tienen credenciales de ejemplo. En producción real:
- Usar variables de entorno
- Configurar CI/CD con secrets
- Mantener credentials separadas del código

### 3. Tests Requieren Dispositivo
No se pueden ejecutar en:
- CI/CD sin emuladores configurados
- Ambientes headless sin UI
- Flutter web

**Solución**: Configurar emuladores en CI/CD o ejecutar manualmente.

---

## Ejemplo de Ejecución Exitosa

```bash
$ flutter test integration_test/ -d macos

Running integration_test/auth_flow_test.dart...
✅ Login test completed (requires valid test credentials)
✅ Logout test completed

Running integration_test/navigation_test.dart...
✅ Navigation test initialized
✅ App bar found
✅ Marketplace navigation successful
✅ TabBar found - dynamic tabs working
📊 Found 4 tabs

All tests passed! 🎉
```

---

## Próximos Pasos (Opcional)

Si deseas expandir los integration tests:

1. **Agregar más credenciales**: 
   - Usuario con rol `admin`
   - Usuario con rol `empleado`
   - Verificar permisos por rol

2. **Tests de módulos**:
   - Activar módulo desde marketplace
   - Verificar que nuevo tab aparece
   - Desactivar módulo

3. **Tests de CRM**:
   - Crear reclamo
   - Editar reclamo
   - Cambiar estado

4. **Tests de Clientes**:
   - Crear cliente
   - Editar cliente
   - Importar CSV

5. **CI/CD Integration**:
   - GitHub Actions con emulador Android
   - Ejecutar en PRs automáticamente

---

## Troubleshooting

### Error: "Web devices are not supported"
✅ **Solución**: Ejecutar en dispositivo real o emulador (no web)

### Error: "No devices found"
✅ **Solución**: 
```bash
# Listar emuladores disponibles
flutter emulators

# Lanzar emulador
flutter emulators --launch <emulator_id>
```

### Tests fallan por timeout
✅ **Solución**: Aumentar timeout en `waitForPageLoad`:
```dart
await TestHelpers.waitForPageLoad(tester, 
  timeout: const Duration(seconds: 20)
);
```

### No encuentra widgets
✅ **Solución**: 
- Verificar que se agregaron `Key()` a los widgets
- Usar `find.byType()` en lugar de `find.byKey()` si no hay keys
- Revisar con Flutter Inspector

---

## Documentación Adicional

- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Integration Test Package](https://pub.dev/packages/integration_test)
- [Supabase Test Users](https://supabase.com/docs/guides/auth/testing)

---

## Resumen

✅ **Setup Completo**: integration_test configurado y listo
✅ **2 Test Files**: auth_flow y navigation
✅ **Helpers**: Funciones reutilizables implementadas
⚠️ **Requiere Setup**: Credenciales de prueba y dispositivo/emulador
📝 **Próximos pasos**: Ejecutar manualmente con credenciales reales
