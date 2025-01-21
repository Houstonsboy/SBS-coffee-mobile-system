import 'package:coffee_system/Authentication/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_system/Authentication/global.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Future<void> logout(BuildContext context) async {
      try {
        await FirebaseAuth.instance.signOut(); // Firebase sign-out
        await clearGlobalVariables();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AuthScreen()), // Redirect to login page
        );
      } catch (e) {
        // Display an error message if logout fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out: $e')),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          // Add the logout button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => logout(context), // Call the logout function
                tooltip: 'Logout',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // Wrap the Text widgets inside a Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: $globalEmail',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: $globalUsername',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User ID: $globalUserId',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Phone: $globalPhone',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
