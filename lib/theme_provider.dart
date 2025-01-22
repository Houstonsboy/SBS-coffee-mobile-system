import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isSystemTheme = true;

  final String _themePreferenceKey = 'theme_preference';
  final String _systemThemeKey = 'system_theme';

  bool get isDarkMode => _isDarkMode;
  bool get isSystemTheme => _isSystemTheme;

  ThemeProvider(){
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async{
    final prefs = await SharedPreferences.getInstance();
    _isSystemTheme = prefs.getBool(_systemThemeKey) ?? true;

    if(_isSystemTheme){
      //get system theme
      var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    } else{
      _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async{
    _isDarkMode = !_isDarkMode;
    _isSystemTheme = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
    await prefs.setBool(_systemThemeKey, false);
    notifyListeners();
  }

  Future<void> setSystemTheme() async{
    _isSystemTheme = true;
    var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_systemThemeKey, true);
    notifyListeners();
  }

  void handleSystemThemeChange(){
    if(_isSystemTheme){
      var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
  }

  ThemeData get themeData {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
    ),

  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
    ),

  );
}