// menuitems.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menuscrollable.dart';

class MenuItems extends StatefulWidget {
  final Function(int) onItemTapped;

  const MenuItems({required this.onItemTapped, super.key});

  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MenuItem('Classic', 0, _handleTap, _selectedIndex == 0),
            MenuItem('Smoothies', 1, _handleTap, _selectedIndex == 1),
            MenuItem('Winter Warmers', 2, _handleTap, _selectedIndex == 2),
            MenuItem('Summer Coolers', 3, _handleTap, _selectedIndex == 3),
            MenuItem('Signatures', 4, _handleTap, _selectedIndex == 4),
          ],
        ),
      ),
    );
  }

  void _handleTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
  }
}

class MenuItem extends StatelessWidget {
  final String label;
  final int index;
  final Function(int) onTap;
  final bool isSelected;

  const MenuItem(this.label, this.index, this.onTap, this.isSelected,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.brown.shade50 : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Colors.brown : Colors.brown.shade200,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        onPressed: () => onTap(index),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: isSelected ? Colors.brown : Colors.brown.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
