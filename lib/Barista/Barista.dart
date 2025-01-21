import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BaristaDashboard extends StatefulWidget {
  const BaristaDashboard({Key? key}) : super(key: key);

  @override
  State<BaristaDashboard> createState() => _BaristaDashboardState();
}

class _BaristaDashboardState extends State<BaristaDashboard>
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
        if (orders.isNotEmpty) {
          _tabController = TabController(length: orders.length, vsync: this);
        }
      });

      _updateCategoryCounts();
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
      });
    } catch (e) {
      print('Error fetching coffees: $e');
    }
  }

  void _updateCategoryCounts() {
    categoryCounts = {};
    for (var order in orders) {
      String category = _getCategoryForCoffee(order['coffee_title']);
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }
  }

  String _getCategoryForCoffee(String coffeeTitle) {
    for (var coffee in coffees) {
      if (coffee['coffee_title'] == coffeeTitle) {
        return coffee['category'];
      }
    }
    return 'Unknown';
  }

  Future<String> _getUserName(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return '${data['firstName']} ${data['lastName']}';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Unknown User';
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
        // Top section with total orders and categories
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.brown.shade900,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Total Orders: ${orders.length}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Category tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryCounts.entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Order list
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: orders.map((order) {
              return FutureBuilder<String>(
                future: _getUserName(order['userId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String userName = snapshot.data ?? 'Unknown User';
                    return OrderCard(order: order, userName: userName);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String userName;

  const OrderCard({Key? key, required this.order, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order['coffee_title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ordered by: $userName',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${order['location']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cup Size: ${order['cup_size']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: Ksh ${order['price']}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement mark as ready functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Mark as Ready'),
                ),
                Text(
                  '${order['time']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
