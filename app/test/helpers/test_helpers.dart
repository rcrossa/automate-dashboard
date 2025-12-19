import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:msasb_app/l10n/generated/app_localizations.dart';

/// Wraps a widget with [ProviderScope] and [MaterialApp] for testing.
/// 
/// [overrides] allows mocking specific providers.
Widget createTestWidget({
  required Widget child,
  List overrides = const [],
}) {
  return ProviderScope(
    overrides: List.castFrom(overrides),
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      locale: const Locale('es'), // Force Spanish for consistent testing
      home: child,
    ),
  );
}

/// Helper to pump a widget wrapped in the test environment
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget child, {
  List overrides = const [],
}) async {
  await tester.pumpWidget(createTestWidget(child: child, overrides: overrides));
  await tester.pumpAndSettle();
}
