import 'package:flutter/material.dart';

class SummerCoolersScreen extends StatelessWidget {
  const SummerCoolersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summer Coolers'),
      ),
      body: Center(
        child: const Text('Summer Coolers menu will be displayed here.'),
      ),
    );
  }
}
