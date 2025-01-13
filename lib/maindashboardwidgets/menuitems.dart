import 'package:flutter/material.dart';

class MenuItems extends StatefulWidget {
  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  // Variable to track the active tab index
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Make it horizontal scrollable
        child: Row(
          children: [
            MenuItem('Classic', 0, _activeIndex, _onItemTapped),
            MenuItem('Smoothies', 1, _activeIndex, _onItemTapped),
            MenuItem('Winter Warmers', 2, _activeIndex, _onItemTapped),
            MenuItem('Summer Coolers', 3, _activeIndex, _onItemTapped),
            MenuItem('Signatures', 4, _activeIndex, _onItemTapped),
            // Add more items as needed
          ],
        ),
      ),
    );
  }

  // Method to handle tab tap and update active index
  void _onItemTapped(int index) {
    setState(() {
      _activeIndex = index;
    });
  }
}

class MenuItem extends StatelessWidget {
  final String label;
  final int index;
  final int activeIndex;
  final Function(int) onTap;

  const MenuItem(this.label, this.index, this.activeIndex, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () {
          onTap(index); // Update the active tab index when a menu item is tapped
        },
        style: TextButton.styleFrom(
          backgroundColor: activeIndex == index ? Colors.grey : Colors.transparent, // Change background if active
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: activeIndex == index ? Colors.white : Colors.black, // Change text color if active
          ),
        ),
      ),
    );
  }
}
