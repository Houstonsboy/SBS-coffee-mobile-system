import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> coffees = [];
  Map<String, int> categoryCounts = {};
  bool isLoading = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _fetchCoffees();
  }

  Future<void> _fetchOrders() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('ready', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> fetchedOrders = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        fetchedOrders.add(data);
      }

      setState(() {
        orders = fetchedOrders;
        _updateCategoryCounts();

        if (categoryCounts.isNotEmpty) {
          _tabController =
              TabController(length: categoryCounts.keys.length, vsync: this);
        }
      });

      isLoading = false;
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCoffees() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('coffee').get();

      List<Map<String, dynamic>> fetchedCoffees = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        fetchedCoffees.add(data);
      }

      setState(() {
        coffees = fetchedCoffees;
        _updateCategoryCounts();
      });
    } catch (e) {
      print('Error fetching coffees: $e');
    }
  }

  void _updateCategoryCounts() {
    if (orders.isEmpty || coffees.isEmpty) return;

    Map<String, int> newCategoryCounts = {};
    for (var order in orders) {
      String category = _getCategoryForCoffee(order['coffee_title'] ?? '');
      newCategoryCounts[category] = (newCategoryCounts[category] ?? 0) + 1;
    }
    setState(() {
      categoryCounts = newCategoryCounts;
      if (categoryCounts.isNotEmpty) {
        _tabController = TabController(
            length: categoryCounts.keys.length, vsync: this, initialIndex: 0);
      }
    });
  }

  String _getCategoryForCoffee(String coffeeTitle) {
    for (var coffee in coffees) {
      if (coffee['coffee_title'] == coffeeTitle) {
        return coffee['category'] ?? 'Unknown';
      }
    }
    return 'Unknown';
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

    if (_tabController == null && categoryCounts.isNotEmpty) {
      _tabController =
          TabController(length: categoryCounts.keys.length, vsync: this);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // "Total Orders" text at the top
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
            child: Text(
              'Total Orders: ${orders.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          // Top section with categories
          Container(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 35, // Compact category nav bar
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.brown.shade900,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.brown.shade100,
                ),
                tabs: categoryCounts.keys.map((category) {
                  return Tab(text: '$category (${categoryCounts[category]})');
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Order list (Horizontal scrolling)
          Expanded(
            child: _tabController != null
                ? TabBarView(
                    controller: _tabController,
                    children: categoryCounts.keys.map((category) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: orders
                            .where((order) =>
                                _getCategoryForCoffee(
                                    order['coffee_title'] ?? '') ==
                                category)
                            .length,
                        itemBuilder: (context, index) {
                          final order = orders
                              .where((order) =>
                                  _getCategoryForCoffee(
                                      order['coffee_title'] ?? '') ==
                                  category)
                              .toList()[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: OrderCard(order: order),
                          );
                        },
                      );
                    }).toList(),
                  )
                : const Center(child: Text('No categories found')),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 300, // Set width directly
        height: 150,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order['coffee_title'] ?? 'Unknown Coffee',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${order['location'] ?? 'Not specified'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Price: Ksh ${order['price'] ?? '0.0'}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
