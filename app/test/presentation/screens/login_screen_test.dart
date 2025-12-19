import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/presentation/providers/auth_repository_provider.dart';
import 'package:msasb_app/presentation/screens/auth/login_pantalla.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_mocks.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LoginScreen smoke test - renders correctly', (WidgetTester tester) async {
    await pumpTestWidget(tester, const LoginPantalla());

    // Verify fields via Keys
    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('LoginScreen toggles to Register mode', (WidgetTester tester) async {
    await pumpTestWidget(tester, const LoginPantalla());

    // Switch to Register
    await tester.tap(find.byKey(const Key('auth_mode_switch')));
    await tester.pump();

    // Verify Register fields appear
    expect(find.byKey(const Key('register_name_field')), findsOneWidget);
    expect(find.byKey(const Key('register_username_field')), findsOneWidget);
    expect(find.byKey(const Key('register_submit_button')), findsOneWidget);
  });

  testWidgets('LoginScreen calls login on submit', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await pumpTestWidget(
      tester,
      const LoginPantalla(),
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    // Enter valid credentials
    await tester.enterText(find.byKey(const Key('login_email_field')), 'test@test.com');
    await tester.enterText(find.byKey(const Key('login_password_field')), '123456');

    // Tap Login
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pump(); // Start logic
    await tester.pump(const Duration(milliseconds: 600)); // Complete async/animation
    
    // As per previous findings, we expect localized success text
    expect(find.textContaining('Login exitoso'), findsOneWidget);
  });
}
