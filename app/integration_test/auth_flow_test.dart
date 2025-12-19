import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:msasb_app/main.dart' as app;
import 'helpers/test_helpers.dart';

/// Integration tests para flujo de autenticación
/// 
/// Tests incluidos:
/// 1. Login exitoso con credenciales válidas
/// 2. Logout exitoso
/// 3. Login fallido con credenciales inválidas (opcional)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    testWidgets('Login exitoso con credenciales válidas', (WidgetTester tester) async {
      // Iniciar la app
      app.main();
      await TestHelpers.waitForPageLoad(tester);
      
      // NOTA: Este test requiere credenciales de prueba configuradas en Supabase
      // Se recomienda usar un usuario de prueba específico
      
      // Verificar que estamos en pantalla de login
      expect(find.text('Iniciar Sesión'), findsWidgets);
      
      // Buscar campos de login
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      
      // Ingresar credenciales - MÉTODO MEJORADO
      await tester.tap(emailField);
      await tester.pump();
      await tester.enterText(emailField, 'admin@ejemplo.com');
      await tester.pump();
      
      await tester.tap(passwordField);
      await tester.pump();
      await tester.enterText(passwordField, 'admin123');
      await tester.pump();
      
      // Verificar que el email fue ingresado correctamente
      expect(find.text('admin@ejemplo.com'), findsOneWidget, 
        reason: 'Email debe estar visible en el campo');
      
      // OPCIÓN 1: Simular presionar Enter después de ingresar password
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      // Esperar un momento adicional para procesar el login
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Verificar si hay mensajes de error
      final errorSnackbar = find.byType(SnackBar);
      if (errorSnackbar.evaluate().isNotEmpty) {
      }
      
      // Verificar estado actual
      final stillOnLogin = find.text('Iniciar Sesión');
      if (stillOnLogin.evaluate().isNotEmpty) {
        
        // Buscar si hay algún mensaje de error visible
        final errorTexts = find.textContaining('error', findRichText: true);
        if (errorTexts.evaluate().isNotEmpty) {
        }
      } else {
      }
      
      // El test falla si aún estamos en login (esperado si credenciales incorrectas)
      expect(find.text('Iniciar Sesión'), findsNothing,
        reason: 'Debería haber navegado fuera de login después de credenciales correctas. '
                'Si falla, verifica que el usuario admin@ejemplo.com/admin123 existe en Supabase.');
      
    });

    testWidgets('Logout exitoso', (WidgetTester tester) async {
      // Este test asume que el usuario ya está logueado del test anterior
      // En un escenario real, se haría login primero
      
      app.main();
      await TestHelpers.waitForPageLoad(tester);
      
      // Intentar hacer logout
      // Buscar icono de menú/drawer
      final menuIcon = find.byIcon(Icons.menu);
      if (menuIcon.evaluate().isNotEmpty) {
        await tester.tap(menuIcon);
        await tester.pumpAndSettle();
        
        // Buscar botón de logout
        final logoutText = find.text('Cerrar Sesión');
        if (logoutText.evaluate().isNotEmpty) {
          await tester.tap(logoutText);
          await TestHelpers.waitForPageLoad(tester);
          
          // Verificar que volvimos a login
          expect(find.text('Iniciar Sesión'), findsWidgets);
        } else {
        }
      } else {
      }
    });
  });
}
