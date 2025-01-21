import 'package:flutter/material.dart';
import '../dashboard/searchicon.dart';
import '../dashboard/menuitems.dart';
import '../dashboard/menuscrollable.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int _activeIndex = 0;
  
  // Map to store category images
  final Map<int, String> categoryImages = {
    0: 'images/ClassicsPage.jpg',     // Classic
    1: 'images/SmoothiesPage.jpg',         // Smoothies
    2: 'images/WinterWarmersPage.jpg',     // Winter Warmers
    3: 'images/SummerCoolersPage.jpg',     // Summer Coolers
    4: 'images/SignaturePage.jpg',     // Signatures
  };

  // Get current background image based on active index
  String get currentBackgroundImage => 
    categoryImages[_activeIndex] ?? 'images/SignaturePage.jpg';

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
                  image: AssetImage(currentBackgroundImage),
                  fit: BoxFit.cover,
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
              child: MenuScrollable(selectedIndex: _activeIndex),
            ),
          ),
        ],
      ),
    );
  }
}