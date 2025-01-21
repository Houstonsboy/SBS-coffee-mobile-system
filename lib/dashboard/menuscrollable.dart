import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/global.dart'; // Import global.dart for globalUserId
import '../order/orderpage.dart'; // Import order.dart

class MenuScrollable extends StatelessWidget {
  final int selectedIndex;
  final Map<int, String> categoryMap = {
    0: 'Classic Drinks',
    1: 'Smoothies',
    2: 'Winter Warmers',
    3: 'Summer Coolers',
    4: 'Signature Drinks',
  };

  MenuScrollable({super.key, required this.selectedIndex});

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
            'globalUserId': globalUserId, // From global.dart
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
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items found in this category'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final isClassicDrink =
                categoryMap[selectedIndex] == 'Classic Drinks';
            final data = doc.data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () => navigateToOrder(context, {
                ...data,
                'category': categoryMap[selectedIndex],
              }),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.brown.shade200),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data['coffee_title'] ?? 'Untitled',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isClassicDrink)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Single: Ksh ${data['single']?.toString() ?? 'N/A'}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Double: Ksh ${data['double']?.toString() ?? 'N/A'}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Ksh ${data['price']?.toString() ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
