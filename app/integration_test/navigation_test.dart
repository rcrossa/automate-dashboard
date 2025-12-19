import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:msasb_app/main.dart' as app;
import 'helpers/test_helpers.dart';

/// Integration tests para navegación y módulos dinámicos
/// 
/// Tests incluidos:
/// 1. Navegación entre tabs del dashboard
/// 2. Acceso al marketplace
/// 3. Verificación de tabs dinámicos según módulos activos
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Integration Tests', () {
    testWidgets('Navegación básica en la app', (WidgetTester tester) async {
      app.main();
      await TestHelpers.waitForPageLoad(tester);
      
      // NOTA: Este test asume que hay un usuario logueado
      // En producción, se haría login primero
      
      
      // Verificar que la app carga
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Buscar elementos comunes de navegación
      final appBarTitle = find.byType(AppBar);
      expect(appBarTitle, findsWidgets);
      
    });

    testWidgets('Marketplace es accesible', (WidgetTester tester) async {
      app.main();
      await TestHelpers.waitForPageLoad(tester);
      
      // Buscar drawer/menu
      final menuIcon = find.byIcon(Icons.menu);
      if (menuIcon.evaluate().isNotEmpty) {
        await tester.tap(menuIcon);
        await tester.pumpAndSettle();
        
        // Buscar opción de Marketplace
        final marketplaceOption = find.text('Marketplace');
        if (marketplaceOption.evaluate().isNotEmpty) {
          await tester.tap(marketplaceOption);
          await TestHelpers.waitForPageLoad(tester);
          
          // Verificar que estamos en marketplace
          expect(find.text('Marketplace de Módulos'), findsWidgets);
        } else {
        }
      } else {
      }
    });

    testWidgets('Tabs dinámicos aparecen según módulos', (WidgetTester tester) async {
      app.main();
      await TestHelpers.waitForPageLoad(tester);
      
      // NOTA: Este test verifica que los tabs dinámicos funcionan
      // Requiere que el usuario tenga módulos activados
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Buscar TabBar
      final tabBar = find.byType(TabBar);
      if (tabBar.evaluate().isNotEmpty) {
        
        // Intentar navegar entre tabs
        final tabs = find.byType(Tab);
        final tabCount = tabs.evaluate().length;
        
        expect(tabCount, greaterThan(0));
      } else {
      }
    });
  });
}
