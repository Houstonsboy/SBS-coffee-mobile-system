import 'package:flutter/material.dart';

class MenuScrollable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          color: index % 2 == 0 ? Colors.blue : Colors.red,
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