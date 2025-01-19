import 'package:coffee_system/Authentication/global.dart';
import 'package:flutter/material.dart';
import '../dashboard/searchicon.dart';
import '../homepage/ordertab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.0), // Padding for the text
            child: Text(
              'Welcome Back Chris',
              style: TextStyle(
                fontSize: 30.0, // Font size
                color: Color(0xFF9C4400), // Color
              ),
            ),
          ),
          // Add additional children here
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Whatsup dawg',
              style: TextStyle(
                fontSize: 24.0, // Smaller font size for demonstration
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchIcon(),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Space between text and image
              children: [
                const Text(
                  'Your Basket', // Text on the left
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'images/cigs.jpeg', // Path to your local image
                  height: 50, // Set height to 30px
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              height: 80,
              decoration: BoxDecoration(
                // Linear gradient background
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFCACA), // Light pink color
                    Color(0xFFFFFFFF), // White color
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                // Rounded corners
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'Cappucino',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Ksh 100',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'images/icons8-tick-48.png',
                    height: 30, // Ensure the image fits within 30px height
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
