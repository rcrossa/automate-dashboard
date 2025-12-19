import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helpers comunes para integration tests
class TestHelpers {
  /// Espera a que la página termine de cargar
  static Future<void> waitForPageLoad(WidgetTester tester, {Duration timeout = const Duration(seconds: 5)}) async {
    await tester.pumpAndSettle(timeout);
  }
  
  /// Hace login con credenciales de prueba
  static Future<void> login(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    // Buscar campos de email y password
    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final loginButton = find.byKey(const Key('login_button'));
    
    // Ingresar credenciales
    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    
    // Tap login button
    await tester.tap(loginButton);
    await waitForPageLoad(tester);
  }
  
  /// Hace logout
  static Future<void> logout(WidgetTester tester) async {
    // Abrir drawer/menu
    final drawerButton = find.byTooltip('Open navigation menu');
    if (drawerButton.evaluate().isNotEmpty) {
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();
    }
    
    // Buscar y tap logout button
    final logoutButton = find.text('Cerrar Sesión');
    if (logoutButton.evaluate().isNotEmpty) {
      await tester.tap(logoutButton);
      await waitForPageLoad(tester);
    }
  }
  
  /// Navega a una ruta específica
  static Future<void> navigateTo(WidgetTester tester, String routeName) async {
    // Implementación básica, se puede expandir
    await tester.pumpAndSettle();
  }
  
  /// Verifica que un texto esté visible
  static void expectTextVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }
  
  /// Verifica que un widget por key esté visible
  static void expectKeyVisible(Key key) {
    expect(find.byKey(key), findsOneWidget);
  }
}
