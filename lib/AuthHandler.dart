import 'package:coffee_system/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Authentication/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Authentication/global.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  Future<void> _loadUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          globalUserId = uid;
          globalUsername = '${userData['firstName']} ${userData['lastName']}';
          globalEmail = userData['email'];
          globalPhone = userData['phone'];
          isUserLoggedIn = true;

          await saveGlobalVariables();
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          clearGlobalVariables();
          return const AuthScreen();
        } else {
          _loadUserData(snapshot.data!.uid);
          return const MainScreen();
        }
      },
    );
  }
}
