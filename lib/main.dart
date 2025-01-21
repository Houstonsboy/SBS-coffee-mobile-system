import 'package:flutter/material.dart';
import 'OringeMenuUI/order_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const OrderPage(),
    );
  }
}
