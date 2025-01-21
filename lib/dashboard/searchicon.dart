import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
       
        // boxShadow: [
        //   BoxShadow(
        //     color: CupertinoColors.black.withOpacity(0.1), // Set shadow color
        //     spreadRadius: 0, // Set spread radius
        //   ),
        // ],
      ),
      child: CupertinoSearchTextField(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFE6D3C7),
        Color.fromARGB(255, 247, 234, 226),
      ],
    ), // Set gradient colors here
    borderRadius: BorderRadius.circular(30.0),
    border: Border.all(
      color: Colors.black,
      width: 1.3,
    ),
  ),
  style: TextStyle(
          color: Colors.black, // Set the font color here
        ),
        placeholderStyle: TextStyle(
          color: Colors.black54, // Set the placeholder font color here
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Colors.black, // Set the icon color here
        ),
),
    );
  }
}