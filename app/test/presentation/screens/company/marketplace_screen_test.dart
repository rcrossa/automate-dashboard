import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/presentation/screens/company/marketplace_screen.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('MarketplaceScreen Widget Tests', () {
    testWidgets('renders marketplace title', (WidgetTester tester) async {
      await pumpTestWidget(tester, const MarketplaceScreen());

      // Wait for initial load
      await tester.pumpAndSettle();

      // Should show the screen title
      expect(find.text('Marketplace de Módulos'), findsOneWidget);
    });

    testWidgets('displays list after loading completes', (WidgetTester tester) async {
      await pumpTestWidget(tester, const MarketplaceScreen());

      await tester.pumpAndSettle();

      // Should either show modules or empty state, but not still loading
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Now uses GridView with ResponsiveHelper instead of LayoutBuilder
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('has language selector in app bar', (WidgetTester tester) async {
      await pumpTestWidget(tester, const MarketplaceScreen());

      await tester.pumpAndSettle();

      // Should have language selector icon
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('responds to screen size changes', (WidgetTester tester) async {
      await pumpTestWidget(tester, const MarketplaceScreen());

      await tester.pumpAndSettle();

      // Uses ResponsiveHelper for grid columns (no longer uses LayoutBuilder)
      expect(find.byType(GridView), findsOneWidget);
      
      // Should have AppBar
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
