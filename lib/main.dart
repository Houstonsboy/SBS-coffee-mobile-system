import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: dashboard(),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  // Add home action
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Add favorites action
                },
              ),
              IconButton(
                icon: const Icon(Icons.receipt),
                onPressed: () {
                  // Add receipt action
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Add profile action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}