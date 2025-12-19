import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/presentation/providers/module_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';
import 'package:msasb_app/presentation/screens/user/pantalla_principal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_mocks.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('PantallaPrincipal renders CompanyDashboard for Admin', (WidgetTester tester) async {
    // using default admin session from FakeUserState
    await pumpTestWidget(
      tester,
      PantallaPrincipal(onLogout: () {}),
      overrides: [
        userStateProvider.overrideWith(() => FakeUserState()),
        activeModulesProvider.overrideWith(() => FakeActiveModules(['dashboard'])),
        moduleUpdateStreamProvider.overrideWith((ref) => const Stream.empty()),
      ],
    );
    
    await tester.pumpAndSettle();

    // Verify Company Dashboard renders (looking for Company name from mock)
    expect(find.text('Test Company'), findsOneWidget);
    
    // Verify Dashboard basic tab (Resumen)
    expect(find.text('Resumen'), findsOneWidget);
  });
}
