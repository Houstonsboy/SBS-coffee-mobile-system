// order_tab.dart
import 'package:flutter/material.dart';
import '../firebase/orders.dart';  // Import the firebase.dart file

class OrderTab extends StatefulWidget {
  const OrderTab({super.key});

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  String? coffeeName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoffeeName();
  }

  Future<void> _fetchCoffeeName() async {
    String? coffeeTitle = await fetchCoffeeName();  // Call the function from firebase.dart

    setState(() {
      coffeeName = coffeeTitle;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFCACA), // Light pink color
            Color(0xFFFFFFFF), // White color
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              Text(
                isLoading ? 'Loading...' : coffeeName ?? 'No Name',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Ksh 200',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Image.asset(
            'images/icons8-tick-48.png',
            height: 30, // Ensure the image fits within 30px height
          ),
        ],
      ),
    );
  }
}
