import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menuscrollable.dart'; // Import the MenuScrollable widget

class MenuItems extends StatefulWidget {
  final Function(int) onItemTapped; // Callback to handle menu item selection

  // Constructor that takes onItemTapped as a parameter
  const MenuItems({required this.onItemTapped, Key? key}) : super(key: key);

  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Make it horizontal scrollable
        child: Row(
          children: [
            MenuItem('Classic', 0, widget.onItemTapped),
            MenuItem('Smoothies', 1, widget.onItemTapped),
            MenuItem('Winter Warmers', 2, widget.onItemTapped),
            MenuItem('Summer Coolers', 3, widget.onItemTapped),
            MenuItem('Signatures', 4, widget.onItemTapped),
            // Add more items as needed
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String label;
  final int index;
  final Function(int) onTap;

  const MenuItem(this.label, this.index, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: CupertinoColors.systemBrown,
              width: 1.0,
            )
          ),
        ),
        onPressed: () {
          onTap(index); // Update the active tab index when a menu item is tapped
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
