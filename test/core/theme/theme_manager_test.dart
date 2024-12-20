import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/core/theme/theme_manager.dart';

void main() {
  group('ThemeManager', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should toggle theme and persist to SharedPreferences', () async {
      final themeManager = ThemeManager(ThemeData.light());
      await themeManager.toggleTheme(true);

      expect(themeManager.value, ThemeData.dark());
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkMode'), isTrue);
    });

    test('should load theme from SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', true);

      final theme = await ThemeManager.loadTheme();
      expect(theme, ThemeData.dark());
    });
    // testWidgets('should toggle theme and persist preference',
    //     (WidgetTester tester) async {
    //   // Arrange
    //   final prefs = await SharedPreferences.getInstance();
    //   //expect(prefs.getBool('isDarkMode'), isNull); // Initial state
    //   expect(prefs.getBool('isDarkMode'), isFalse);

    //   await tester.pumpWidget(buildTestableWidget());
    //   final switchFinder = find.byType(Switch);

    //   // Act: Enable dark mode
    //   await tester.tap(switchFinder);
    //   await tester.pumpAndSettle();

    //   // Assert: Verify the dark mode is applied and stored
    //   expect(themeManager.value, ThemeData.dark());
    //   //expect(prefs.getBool('isDarkMode'), true);
    //   expect(prefs.getBool('isDarkMode'), isTrue);

    //   // Act: Disable dark mode
    //   await tester.tap(switchFinder);
    //   await tester.pumpAndSettle();

    //   // Assert: Verify the light mode is applied and stored
    //   expect(themeManager.value, ThemeData.light());
    //   //expect(prefs.getBool('isDarkMode'), false);
    //   expect(prefs.getBool('isDarkMode'), isFalse);
    // });
  });
}
