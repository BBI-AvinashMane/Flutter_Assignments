// core/theme/theme_manager.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ValueNotifier<ThemeData> {
  static const _themeKey = 'isDarkMode';

  ThemeManager(ThemeData theme) : super(theme);

  // Toggle Theme
  Future<void> toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode); // Save preference
    value = isDarkMode ? ThemeData.dark() : ThemeData.light(); // Update theme
  }

  // Load Theme from SharedPreferences
  static Future<ThemeData> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false; // Default to light mode
    return isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
