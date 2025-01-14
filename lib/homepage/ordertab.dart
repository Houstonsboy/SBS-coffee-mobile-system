import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coffee')
          .where('price', isEqualTo: 200)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        setState(() {
          coffeeName = document['name'];
          isLoading = false;
        });
      } else {
        setState(() {
          coffeeName = 'No Coffee Found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        coffeeName = 'Error fetching data';
        isLoading = false;
      });
      print('Error fetching document: $e');
    }
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
