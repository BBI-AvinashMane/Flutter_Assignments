// // core/shared/shared_prefs.dart
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   static const String _themeKey = "themeKey";

//   Future<void> setDarkMode(bool isDark) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_themeKey, isDark);
//   }

//   Future<bool> getDarkMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_themeKey) ?? false;
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _themeKey = "isDarkMode";

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light mode
  }
}
