import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Define your theme-related properties and methods here
  // For example:
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    // Typically, you would switch between light and dark themes
    _themeData = _themeData == ThemeData.light()
        ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
