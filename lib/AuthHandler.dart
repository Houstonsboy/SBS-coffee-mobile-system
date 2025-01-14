import 'package:coffee_system/MainDashboardwidgets/dashboard.dart';
import 'package:coffee_system/homepage/homepage.dart';
import 'package:coffee_system/main.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'Authentication/auth_screen.dart';


class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null) {
          // User is not logged in
          return AuthScreen();
        } else {
          // User is logged in
          return MainScreen();
        }
      },
    );
  }
}
