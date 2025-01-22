import 'package:coffee_system/navigation/profile.dart';
import 'package:coffee_system/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Image.asset(
                'images/school_logos/emblem.png',
                height: 40, // Adjust the height as needed
                width: 40, // Adjust the width as needed
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              }),
        ],
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
