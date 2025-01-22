import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

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
        _updateCategoryCounts(); // Call after orders are updated

        if (categoryCounts.isNotEmpty) {
          // Check if categories are available
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
        _updateCategoryCounts(); // Call after coffees are updated
      });
    } catch (e) {
      print('Error fetching coffees: $e');
    }
  }

  void _updateCategoryCounts() {
    // This function now depends on both orders and coffees being loaded
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
            length: categoryCounts.keys.length,
            vsync: this,
            initialIndex: 0); // Set initial index to 0
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

  Future<String> _getUserName(String userId) async {
    if (userId.isEmpty) {
      log('User ID is empty. Returning "Unknown User".');
      return 'Unknown User';
    }

    try {
      // Log the userId being fetched
      log('Fetching user name for User ID: $userId');

      // Fetch user document directly using its ID
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String firstName = userData['firstName'] ?? '';
        String lastName = userData['lastName'] ?? '';
        String fullName = '$firstName $lastName';

        // Log the fetched user name
        log('Fetched user name: $fullName for User ID: $userId');
        return fullName;
      } else {
        log('No user found for User ID: $userId. Returning "Unknown User".');
        return 'Unknown User';
      }
    } catch (e) {
      log('Error fetching user name for User ID $userId: $e');
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

    // Ensure _tabController is initialized if categoryCounts is not empty
    if (_tabController == null && categoryCounts.isNotEmpty) {
      _tabController =
          TabController(length: categoryCounts.keys.length, vsync: this);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 10, // Adjust this value to make the AppBar more compact
      ),
      body: Column(
        children: [
          // Top section with total orders and categories
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Total Orders: ${orders.length}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                // Category tabs
                SizedBox(
                  height: 35,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                    ),
                    tabs: categoryCounts.keys.map((category) {
                      return Tab(
                          text: '$category (${categoryCounts[category]})');
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Order list
          Expanded(
            child: _tabController !=
                    null // Only render TabBarView if _tabController is initialized
                ? TabBarView(
                    controller: _tabController,
                    children: categoryCounts.keys.map((category) {
                      return ListView.builder(
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
                          return FutureBuilder<String>(
                            future: _getUserName(order['userId'] ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String userName =
                                    snapshot.data ?? 'Unknown User';
                                return OrderCard(
                                    order: order, userName: userName);
                              }
                            },
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
  final String userName;

  const OrderCard({Key? key, required this.order, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6.0), // Reduced margin for compactness
      elevation: 3, // Slightly lower elevation for a sleeker look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjusted for compactness
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding for compactness
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order['coffee_title'] ?? 'Unknown Coffee',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4), // Reduced space
            Text(
              'Ordered by: $userName',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${order['location'] ?? 'Not specified'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.brown.shade300,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cup Size: ${order['cup_size'] ?? 'Not specified'}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Price: Ksh ${order['price'] ?? '0.0'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10), // Reduced space
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement mark as ready functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8), // Compact button
                    textStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Mark as Ready',
                    style: TextStyle(color: Colors.white), // Ensures white text
                  ),
                ),
                Text(
                  '${order['time'] ?? 'Time not available'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
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
