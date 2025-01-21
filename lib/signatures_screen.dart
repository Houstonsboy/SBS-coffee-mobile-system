import 'package:flutter/material.dart';

class SignaturesScreen extends StatelessWidget {
  const SignaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signatures'),
      ),
      body: Center(
        child: const Text('Signatures menu will be displayed here.'),
      ),
    );
  }
}
