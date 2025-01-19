import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/global.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? selectedPrice;
  String? selectedLocation;
  bool isSubmitting = false;

  // Helper method to determine cup size based on selected price
  String getCupSize(String selectedPrice, Map<String, dynamic> priceMap) {
    return selectedPrice == priceMap['single'].toString() ? 'single' : 'double';
  }

  Future<void> submitOrder({
    required String username,
    required String userId,
    required String price,
    required String coffeeTitle,
    required String location,
    required String cupSize,
  }) async {
    try {
      print('Submitting order with data:');
      print('Username: $username');
      print('UserId: $userId');
      print('Price: $price');
      print('Coffee: $coffeeTitle');
      print('Location: $location');
      print('Cup Size: $cupSize');

      setState(() {
        isSubmitting = true;
      });

      final time = DateTime.now();

      final orderData = {
        'username': username,
        'userId': userId,
        'price': price,
        'coffee_title': coffeeTitle,
        'time': time.toIso8601String(),
        'location': location,
        'cup_size': cupSize,
        'ready': false,
      };

      print('Order data being sent to Firestore: $orderData');

      final firestore = FirebaseFirestore.instance;
      print('Firestore instance obtained: ${firestore != null}');

      final docRef = await firestore.collection('orders').add(orderData);
      
      print('Document added successfully with ID: ${docRef.id}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order submitted successfully!")),
      );

      setState(() {
        selectedPrice = null;
        selectedLocation = null;
      });
    } catch (e, stackTrace) {
      print('Error submitting order: $e');
      print('Stack trace: $stackTrace');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit order: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Checking route arguments...');
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print('Route arguments: $args');
    
    final coffeeTitle = args['coffee_title'];
    final isClassicDrink = args['isClassicDrink'];
    final price = isClassicDrink
        ? {'single': args['single'], 'double': args['double']}
        : args['price'];
    final userId = args['globalUserId'];
    final username = globalUsername;

    print('Coffee Title: $coffeeTitle');
    print('User ID: $userId');
    print('Username: $username');

    // For non-classic drinks, set selectedPrice immediately
    if (!isClassicDrink && selectedPrice == null) {
      selectedPrice = price.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Coffee"),
        backgroundColor: const Color(0xFFA57C50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coffee Title: $coffeeTitle",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (isClassicDrink) ...[
              const Text(
                "Select Price:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedPrice,
                hint: const Text("Choose Single or Double"),
                items: [
                  DropdownMenuItem(
                    value: price['single'].toString(),
                    child: Text("Single (Ksh ${price['single']})"),
                  ),
                  DropdownMenuItem(
                    value: price['double'].toString(),
                    child: Text("Double (Ksh ${price['double']})"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPrice = value;
                  });
                },
              ),
            ] else ...[
              Text(
                "Price: Ksh $price",
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 10),

            const Text(
              "Select Location:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedLocation,
              hint: const Text("Choose Location"),
              items: const [
                DropdownMenuItem(
                  value: "SBS",
                  child: Text("SBS"),
                ),
                DropdownMenuItem(
                  value: "Lawschool",
                  child: Text("Lawschool"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isSubmitting || selectedLocation == null
                  ? null // Only check for location selection and submission state
                  : () {
                      // For classic drinks, determine cup size based on selected price
                      // For non-classic drinks, always use 'single' cup size
                      String cupSize = isClassicDrink
                          ? getCupSize(selectedPrice!, price)
                          : 'single';

                      submitOrder(
                        username: username ?? "Unknown",
                        userId: userId,
                        price: selectedPrice!,
                        coffeeTitle: coffeeTitle,
                        location: selectedLocation!,
                        cupSize: cupSize,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA57C50),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("Submit Order", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}