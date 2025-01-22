import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isSystemTheme = true;
  ThemeMode _themeMode = ThemeMode.system;

  final String _themePreferenceKey = 'theme_preference';
  final String _systemThemeKey = 'system_theme';

  bool get isDarkMode => _isDarkMode;
  bool get isSystemTheme => _isSystemTheme;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider(){
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async{
    final prefs = await SharedPreferences.getInstance();
    _isSystemTheme = prefs.getBool(_systemThemeKey) ?? true;

    if(_isSystemTheme){
      //get system theme
      _themeMode = ThemeMode.system;
      var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    } else{
      _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async{
    _isDarkMode = !_isDarkMode;
    _isSystemTheme = false;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
    await prefs.setBool(_systemThemeKey, false);
    notifyListeners();
  }

  Future<void> setSystemTheme() async{
    _isSystemTheme = true;
    _themeMode = ThemeMode.system;
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
    if(_themeMode == ThemeMode.system){
    var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? darkTheme : lightTheme; 
    }else{
      return _themeMode == ThemeMode.dark ? darkTheme :lightTheme;
    }
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade100,
      primary: Colors.deepPurple,
      secondary: Colors.brown.shade100,

    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.brown,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xff7C00FE),
      unselectedItemColor: Colors.grey.shade700,
    ),

  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 35, 35, 35),
      primary: Colors.deepPurple.shade100,
      secondary: Colors.brown.shade100,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xff7C00FE),
      unselectedItemColor: Colors.white,
    ),

  );
}