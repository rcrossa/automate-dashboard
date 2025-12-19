import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/presentation/screens/client/client_list_screen.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('ClientListScreen Widget Tests', () {
    testWidgets('renders scaffold with app bar', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClientListScreen());

      await tester.pumpAndSettle();

      // Should have Scaffold and AppBar
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has search field', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClientListScreen());

      await tester.pumpAndSettle();

      // Should have search field with icon
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('has action buttons', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClientListScreen());

      await tester.pumpAndSettle();

      // Should have some icon buttons in app bar
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('shows list view after loading', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClientListScreen());

      await tester.pumpAndSettle();

      // Should not be loading anymore
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Should have main structure
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
