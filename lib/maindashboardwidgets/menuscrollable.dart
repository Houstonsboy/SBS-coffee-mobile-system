import 'package:flutter/material.dart';

class MenuScrollable extends StatelessWidget {
  final int selectedIndex;

  // Constructor to receive the selected index from the MenuItems widget
  MenuScrollable({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        // Determine the color based on the selected index
        Color itemColor;
        switch (selectedIndex) {
          case 0: // Classic
            itemColor = index % 2 == 0 ? Colors.red : Colors.blue;
            break;
          case 1: // Smoothies
            itemColor = index % 2 == 0 ? Colors.green : Colors.purple;
            break;
          case 2: // Winter Warmers
            itemColor = index % 2 == 0 ? Colors.green : Colors.yellow;
            break;
          case 3: // Summer Coolers
            itemColor = index % 2 == 0 ? Colors.orange : Colors.lightBlue;
            break;
          case 4: // Signatures
            itemColor = index % 2 == 0 ? Colors.pink : Colors.teal;
            break;
          default:
            itemColor = Colors.grey; // Default color for unsupported cases
            break;
        }

        return Container(
          color: itemColor,
          height: 100.0,
          child: Center(
            child: Text(
              "Item ${index + 1}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
