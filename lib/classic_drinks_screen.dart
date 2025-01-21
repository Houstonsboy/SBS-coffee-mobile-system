import 'package:flutter/material.dart';

class ClassicDrinksScreen extends StatelessWidget {
  const ClassicDrinksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic Drinks'),
      ),
      body: Center(
        child: const Text('Classic Drinks menu will be displayed here.'),
      ),
    );
  }
}
