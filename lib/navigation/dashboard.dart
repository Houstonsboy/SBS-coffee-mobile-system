import 'package:flutter/material.dart';
import '../dashboard/searchicon.dart';
import '../dashboard/menuitems.dart'; // Import MenuItems
import '../dashboard/menuscrollable.dart'; // Import MenuScrollable

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  // Variable to store the active index
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Container(
    height: screenHeight / 5,
    width: screenWidth,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/coffee2.jpg'), // Path to your image
        fit: BoxFit.cover, // Ensures the image covers the entire container
      ),
    ),
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
