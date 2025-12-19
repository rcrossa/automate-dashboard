import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/presentation/screens/crm/claims/claims_list_screen.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('ClaimsListScreen Widget Tests', () {
    testWidgets('renders claims list with scaffold', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClaimsListScreen());

      await tester.pumpAndSettle();

      // Should have Scaffold and AppBar
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has search field', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClaimsListScreen());

      await tester.pumpAndSettle();

      // Should have search TextField
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('shows content after loading', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClaimsListScreen());

      await tester.pumpAndSettle();

      // Should not be loading anymore
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Should have main scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has create claim button', (WidgetTester tester) async {
      await pumpTestWidget(tester, const ClaimsListScreen());

      await tester.pumpAndSettle();

      // Should have Floating Action Button to create new claim
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
