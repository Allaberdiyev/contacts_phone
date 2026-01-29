import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharePrefs {
  static const _themeMode = 'theme_mode';
  static const _localeCode = 'locale_code';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeMode, mode.name);
  }

  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_themeMode) ?? ThemeMode.light.name;
    return ThemeMode.values.firstWhere(
      (e) => e.name == v,
      orElse: () => ThemeMode.light,
    );
  }

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCode, locale.languageCode);
  }

  static Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeCode);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }
}
