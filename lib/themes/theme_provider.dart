import 'package:flutter/material.dart';
import 'package:music_player_minimal/themes/dark_mode.dart';
import 'package:music_player_minimal/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // starts with light mode
  ThemeData _themeData = lightMode;

  //getter to read private var
  ThemeData get themeData => _themeData;

  // is dark mode boolean getter
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // notifies the widgets to update UI
    notifyListeners();
  }

  // change theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
