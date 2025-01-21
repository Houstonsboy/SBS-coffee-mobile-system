import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'barista_dashboard.dart'; // Import the OrdersScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barista Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const BaristaDashboard(), // Start with the Barista Dashboard
    );
  }
}
