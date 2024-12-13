import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _themeKey = "isDarkMode";

  // Save the dark mode preference
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // Get the dark mode preference
  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light mode
  }
}
