import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msasb_app/utils/responsive_helper.dart';

void main() {
  group('ResponsiveHelper Tests', () {
    testWidgets('isMobile detects mobile screens correctly', (tester) async {
      // Setup mobile screen size (375x667 - iPhone SE)
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isMobile(context), true);
              expect(ResponsiveHelper.isTablet(context), false);
              expect(ResponsiveHelper.isDesktop(context), false);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Reset for other tests
      addTearDown(tester.view.reset);
    });
    
    testWidgets('isTablet detects tablet screens correctly', (tester) async {
      // Setup tablet screen size (768x1024 - iPad)
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isMobile(context), false);
              expect(ResponsiveHelper.isTablet(context), true);
              expect(ResponsiveHelper.isDesktop(context), false);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.view.reset);
    });
    
    testWidgets('isDesktop detects desktop screens correctly', (tester) async {
      // Setup desktop screen size (1920x1080)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.isMobile(context), false);
              expect(ResponsiveHelper.isTablet(context), false);
              expect(ResponsiveHelper.isDesktop(context), true);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.view.reset);
    });
    
    testWidgets('getResponsivePadding returns correct values', (tester) async {
      // Test mobile padding
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getResponsivePadding(context), 16.0);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test tablet padding
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getResponsivePadding(context), 24.0);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test desktop padding
      tester.view.physicalSize = const Size(1920, 1080);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getResponsivePadding(context), 32.0);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.view.reset);
    });
    
    testWidgets('getGridCrossAxisCount returns correct column count', (tester) async {
      // Test mobile: 2 columns
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridCrossAxisCount(context), 2);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test tablet: 3 columns
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridCrossAxisCount(context), 3);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test desktop: 4 columns
      tester.view.physicalSize = const Size(1920, 1080);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getGridCrossAxisCount(context), 4);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.view.reset);
    });
    
    testWidgets('getMaxContentWidth returns correct limits', (tester) async {
      // Test mobile: no limit (infinity)
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                ResponsiveHelper.getMaxContentWidth(context), 
                double.infinity
              );
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test tablet: 900px
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getMaxContentWidth(context), 900);
              return const SizedBox();
            },
          ),
        ),
      );
      
      // Test desktop: 1200px
      tester.view.physicalSize = const Size(1920, 1080);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveHelper.getMaxContentWidth(context), 1200);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.view.reset);
    });
    
    test('breakpoint constants are Material Design compliant', () {
      expect(ResponsiveHelper.mobileBreakpoint, 600);
      expect(ResponsiveHelper.tabletBreakpoint, 1200);
    });
  });
}
