import 'package:coffee_system/MainDashboardwidgets/dashboard.dart';
import 'package:coffee_system/homepage/homepage.dart';
import 'package:coffee_system/main.dart';
import 'package:flutter/material.dart';
import 'UserProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Authentication/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthHandler extends StatelessWidget {
  Future<void> _loadUserData(String uid, BuildContext context) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        // Update provider instead of global variables
        context.read<UserProvider>().setUserData(
          uid,
          userDoc.data()?['username'],
        );
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
          return AuthScreen();
        } else {
          _loadUserData(snapshot.data!.uid, context);
          return MainScreen();
        }
      },
    );
  }
}