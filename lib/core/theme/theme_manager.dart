import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ValueNotifier<ThemeData> {
  static const _themeKey = 'isDarkMode';

  ThemeManager(ThemeData theme) : super(theme);

  // Toggle the theme and save to SharedPreferences
  Future<void> toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
    value = isDarkMode ? ThemeData.dark() : ThemeData.light();
  }

  // Load theme from SharedPreferences
  static Future<ThemeData> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    return isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
