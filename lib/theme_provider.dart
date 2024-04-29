import 'package:flutter/material.dart';

class ThemeNotifer extends ChangeNotifier {
  bool isLighTheme = false;
  void changeTheme() {
    isLighTheme = !isLighTheme;
    notifyListeners();
  }

  ThemeData get currentTheme =>
      !isLighTheme ? ThemeData.dark() : ThemeData.light();
}
