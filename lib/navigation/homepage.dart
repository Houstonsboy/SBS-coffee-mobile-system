import 'dart:math';

import 'package:coffee_system/Authentication/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getGreeting(){
    final hour=DateTime.now().hour;
    if(hour < 12){
      return 'Good Morning!';
    } else if(hour < 18){
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String getEmoji(){
    final hour=DateTime.now().hour;
    if(hour < 12){
      return '🌞';
    } else if(hour < 18){
      return '🪭';
    } else {
      return '🌚';
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: globalUserId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Hi, ${globalUsername ?? ''} ${getEmoji()}',
              style: TextStyle(
                fontSize: 24.0, // Font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              getGreeting(),
              style: TextStyle(
                fontSize: 24.0, // Font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Basket',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'images/cigs.jpeg', // Path to your local image
                  height: 50, // Set height to 30px
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No orders found.'));
                } else {
                  final orders = snapshot.data!;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFCACA),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['coffee_title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Ksh ${order['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (order['ready'] == true)
                                    Text(
                                      'Ordered at: ${DateTime.parse(order['time']).toLocal()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              Icon(
                                order['ready']
                                    ? Icons.check_circle
                                    : Icons.hourglass_empty,
                                color: order['ready'] ? Colors.green : Colors.orange,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
