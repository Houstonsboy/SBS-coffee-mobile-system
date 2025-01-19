// global.dart
import 'package:shared_preferences/shared_preferences.dart';

String? globalUserId;
String? globalUsername;
String? globalEmail;
String? globalPhone;
bool isUserLoggedIn = false; // Tracks login status

Future<void> saveGlobalVariables() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('globalUserId', globalUserId ?? '');
  prefs.setString('globalUsername', globalUsername ?? '');
  prefs.setString('globalEmail', globalEmail ?? '');
  prefs.setString('globalPhone', globalPhone ?? '');
  prefs.setBool('isUserLoggedIn', isUserLoggedIn);
}

Future<void> loadGlobalVariables() async{
  final prefs = await SharedPreferences.getInstance();
  globalUserId = prefs.getString('globalUserId');
  globalUsername = prefs.getString('globalUsername');
  globalEmail = prefs.getString('globalEmail');
  globalPhone = prefs.getString('globalPhone');
  isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  
  print("Global Email: $globalEmail");
  print("Global UserId: $globalUserId");
}

Future<void> clearGlobalVariables() async{
  globalUserId=null;
  globalUsername=null;
  globalEmail=null;
  globalPhone=null;
  isUserLoggedIn=false;
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}