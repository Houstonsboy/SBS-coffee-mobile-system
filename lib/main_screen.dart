import 'package:coffee_system/navigation/profile.dart';
import 'package:flutter/material.dart';
import 'navigation/homepage.dart';
import 'navigation/dashboard.dart';
import 'navigation/addcoffee.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }
  
  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // List of widgets corresponding to each tab
  final List<Widget> _pages = [
    const HomePage(),
    dashboard(),
    AddCoffeeItem(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Dynamically change the body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current active tab
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Receipts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
