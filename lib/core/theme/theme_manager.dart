// core/theme/theme_manager.dart
import 'package:flutter/material.dart';

class ThemeManager extends ValueNotifier<ThemeData> {
  ThemeManager(ThemeData value) : super(value);

  void toggleTheme(bool isDarkMode) {
    value = isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
