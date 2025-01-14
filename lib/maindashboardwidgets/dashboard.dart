import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/auth_screen.dart'; // Import your login page or AuthHandler
import 'searchicon.dart';
import 'menuitems.dart'; // Import MenuItems
import 'menuscrollable.dart'; // Import MenuScrollable

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  // Variable to store the active index
  int _activeIndex = 0;

  // Function to handle logout
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()), // Redirect to login page
      );
    } catch (e) {
      // Display an error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: screenHeight / 5,
              width: screenWidth,
              color: Colors.brown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchIcon(),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MenuItems(
              onItemTapped: (index) {
                setState(() {
                  _activeIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: MenuScrollable(selectedIndex: _activeIndex), // Pass the selectedIndex to MenuScrollable
            ),
          ),
        ],
      ),
    );
  }
}
