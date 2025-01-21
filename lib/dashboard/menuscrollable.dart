import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/global.dart';
import '../order/orderpage.dart';

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
            'globalUserId': globalUserId,
            'isClassicDrink': coffeeData['category'] == 'Classic Drinks',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      decoration: BoxDecoration(
        color: Color(0xffE6D3C7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
              ),
             border: Border(
                  top: BorderSide(
                    color: Colors.black87, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                  left: BorderSide(
                    color: Colors.black87, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                  right: BorderSide(
                    color: Colors.black87, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('coffee')
            .where('category', isEqualTo: categoryMap[selectedIndex])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.brown[700],
                  fontSize: 16,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[400]!),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No items found in this category',
                style: TextStyle(
                  color: Colors.brown[700],
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final isClassicDrink = categoryMap[selectedIndex] == 'Classic Drinks';
              final data = doc.data() as Map<String, dynamic>;
              final bool isAvailable = data['available'] ?? true;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isAvailable ? 1.0 : 0.7,
                child: GestureDetector(
                  onTap: isAvailable
                      ? () => navigateToOrder(context, {
                            ...data,
                            'category': categoryMap[selectedIndex],
                          })
                      : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    height: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: isAvailable
                            ? Colors.brown.shade200
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      color: isAvailable ? Colors.white : Colors.grey.shade50,
                      boxShadow: isAvailable
                          ? [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      gradient: isAvailable
                          ? LinearGradient(
                              colors: [
                                Color(0xFFFFCACA),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(width: 100), // Space for image
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 200,  // Adjust this value based on your needs
                                      ),
                                      child: Text(
                                        data['coffee_title'] ?? 'Untitled',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: isAvailable
                                              ? Color(0xFF3A322C)
                                              : Colors.grey.shade600,
                                          letterSpacing: 0.2,
                                        ),
                                        textAlign: TextAlign.right,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    if (!isAvailable) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          'Unavailable',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                    Spacer(),
                                    // Price information at the bottom
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: isClassicDrink
                                          ? [
                                              Text(
                                                'Single: Ksh ${data['single']?.toString() ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: isAvailable
                                                      ? Colors.green.shade700
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                'Double: Ksh ${data['double']?.toString() ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: isAvailable
                                                      ? Colors.green.shade700
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ]
                                          : [
                                              Text(
                                                'Ksh ${data['price']?.toString() ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: isAvailable
                                                      ? Colors.green.shade700
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 8.0,
                          bottom: 4.0,
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage('images/school_logos/sample.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if (!isAvailable)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                border: Border.all(
                                  color: Colors.red.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Out of Stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
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
      ),
    );
  }
}