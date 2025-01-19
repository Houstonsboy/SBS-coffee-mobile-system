import 'package:flutter/cupertino.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
       
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1), // Set shadow color
            spreadRadius: 1.0, // Set spread radius
          ),
        ],
      ),
      child: CupertinoSearchTextField(
         decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),)
      ),
    );
  }
}