import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/global.dart';

class OrderTab extends StatefulWidget {
  const OrderTab({super.key});

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  double totalPrice = 0.0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Helper function to safely convert price to double
  double parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }
    return 0.0;
  }

  Future<void> _fetchOrders() async {
    try {
      final userId = globalUserId;
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('ready', isEqualTo: true)
          .get();

      print('Fetching orders for userId: $userId');
      print('Query snapshot size: ${snapshot.docs.length}');

      double calculatedTotalPrice = 0.0;
      List<Map<String, dynamic>> fetchedOrders = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Convert the price to double
        double itemPrice = parsePrice(data['price']);
        data['price'] = itemPrice; // Update the price in the data map
        fetchedOrders.add(data);
        calculatedTotalPrice += itemPrice;
      }

      setState(() {
        orders = fetchedOrders;
        totalPrice = calculatedTotalPrice;
        isLoading = false;
        if (orders.isNotEmpty) {
          _tabController = TabController(length: orders.length, vsync: this);
        }
      });

      print('Processed orders: ${orders.length}');
      print('Total price calculated: $totalPrice');

    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders found!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: [
        Container(
          color: Colors.brown.shade50,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.brown.shade300,
            indicatorColor: Colors.brown,
            tabs: orders.map((order) {
              return Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        order['coffee_title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Ready',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: orders.map((order) {
              return Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['coffee_title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Price: Ksh ${order['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status: Ready',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            border: Border(
              top: BorderSide(
                color: Colors.brown.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ksh ${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}