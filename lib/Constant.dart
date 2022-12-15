import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const String appName = "Alarm Manager Example";
const String durationSeconds = "Seconds";
const String durationMinutes = "Minutes";
const String durationHours = "Hours";
const String oneShotAlarm = "oneShot";
const String oneShotAtAlarm = "oneShotAt";
const String periodicAlarm = "periodic";
const Color primaryColor = Colors.blueAccent;

class Themes {
  static final lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
      brightness: Brightness.light);

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    backgroundColor: Colors.white12,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
