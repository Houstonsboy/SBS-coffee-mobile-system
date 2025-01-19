import 'package:flutter/material.dart';

class MenuItems extends StatefulWidget {
  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  int _activeIndex = 0;

  // Create different lists of colors for each menu category
  final List<List<Color>> categoryColors = [
    [Colors.blue[200]!, Colors.blue[400]!], // Classic
    [Colors.pink[200]!, Colors.pink[400]!], // Smoothies
    [Colors.orange[200]!, Colors.orange[400]!], // Winter Warmers
    [Colors.teal[200]!, Colors.teal[400]!], // Summer Coolers
    [Colors.purple[200]!, Colors.purple[400]!], // Signatures
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Menu Items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MenuItem('Classic', 0, _activeIndex, _onItemTapped),
                MenuItem('Smoothies', 1, _activeIndex, _onItemTapped),
                MenuItem('Winter Warmers', 2, _activeIndex, _onItemTapped),
                MenuItem('Summer Coolers', 3, _activeIndex, _onItemTapped),
                MenuItem('Signatures', 4, _activeIndex, _onItemTapped),
              ],
            ),
          ),
        ),
        
        // Scrollable Container List
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                color: index % 2 == 0 
                    ? categoryColors[_activeIndex][0] 
                    : categoryColors[_activeIndex][1],
                height: 100.0,
                child: Center(
                  child: Text(
                    "${_getMenuTitle(_activeIndex)} Item ${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMenuTitle(int index) {
    switch (index) {
      case 0:
        return "Classic";
      case 1:
        return "Smoothie";
      case 2:
        return "Winter";
      case 3:
        return "Summer";
      case 4:
        return "Signature";
      default:
        return "";
    }
  }

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
          onTap(index);
        },
        style: TextButton.styleFrom(
          backgroundColor: activeIndex == index ? Colors.grey : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: activeIndex == index ? Colors.white : Colors.black,
            fontWeight: activeIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}