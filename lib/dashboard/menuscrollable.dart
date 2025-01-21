import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/global.dart';  // Import global.dart for globalUserId
import '../order/orderpage.dart';     // Import order.dart
class MenuScrollable extends StatelessWidget {
  final int selectedIndex;
  final Map<int, String> categoryMap = {
    0: 'Classic Drinks',
    1: 'Smoothies',
    2: 'Winter Warmers',
    3: 'Summer Coolers',
    4: 'Signature Drinks',
  };

  MenuScrollable({required this.selectedIndex});

  void navigateToOrder(BuildContext context, Map<String, dynamic> coffeeData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(),
        settings: RouteSettings(
          arguments: {
            'coffee_title': coffeeData['coffee_title'],
            'price': coffeeData['price'],
            'single': coffeeData['single'],
            'double': coffeeData['double'],
            'globalUserId': globalUserId,  // From global.dart
            'isClassicDrink': coffeeData['category'] == 'Classic Drinks',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('coffee')
          .where('category', isEqualTo: categoryMap[selectedIndex])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items found in this category'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final isClassicDrink = categoryMap[selectedIndex] == 'Classic Drinks';
            final data = doc.data() as Map<String, dynamic>;
            final bool isAvailable = data['available'] ?? true;

            return GestureDetector(
              onTap: isAvailable 
                  ? () => navigateToOrder(context, {
                      ...data,
                      'category': categoryMap[selectedIndex],
                    })
                  : null,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isAvailable 
                        ? Colors.brown.shade200 
                        : Colors.grey.shade300,
                  ),
                  color: isAvailable ? Colors.white : Colors.grey.shade100,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['coffee_title'] ?? 'Untitled',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: isAvailable 
                                        ? Colors.black 
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                if (!isAvailable) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Unavailable',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: isAvailable ? 1.0 : 0.5,
                            child: isClassicDrink
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Single: Ksh ${data['single']?.toString() ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: isAvailable 
                                            ? Colors.black 
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Double: Ksh ${data['double']?.toString() ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: isAvailable 
                                            ? Colors.black 
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Ksh ${data['price']?.toString() ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: isAvailable 
                                        ? Colors.black 
                                        : Colors.grey.shade600,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!isAvailable)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}