// user_provider.dart
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _username;

  String? get userId => _userId;
  String? get username => _username;

  void setUserData(String? uid, String? username) {
    _userId = uid;
    _username = username;
    notifyListeners();
  }

  void clearUserData() {
    _userId = null;
    _username = null;
    notifyListeners();
  }
}