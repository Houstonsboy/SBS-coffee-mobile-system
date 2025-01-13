import 'package:flutter/material.dart';
import 'maindashboardwidgets/searchicon.dart';
import 'maindashboardwidgets/menuitems.dart';

import 'maindashboardwidgets/menuscrollable.dart';

class dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee System'),
        centerTitle: true,
        flexibleSpace: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: screenHeight / 5,
              width: screenWidth,
              color: Colors.brown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchIcon(),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MenuItems(),
          ),
          Expanded(  // This ensures the MenuScrollable takes the remaining space
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 200, // Or any fixed height you want
                child: MenuScrollable(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
