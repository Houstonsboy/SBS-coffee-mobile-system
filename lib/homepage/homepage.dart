import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0), // Padding for the text
            child: Text(
              'Welcome Back Chris',
              style: TextStyle(
                fontSize: 48.0, // Font size
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
        ],
      ),
    );
  }
}
