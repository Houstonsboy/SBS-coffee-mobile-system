import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoffeeItem extends StatelessWidget {
  final TextEditingController coffeeTitleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddCoffeeItem({super.key});

  Future<void> addCoffeeItem(BuildContext context) async {
    final String coffeeTitle = coffeeTitleController.text.trim();
    final String priceText = priceController.text.trim();

    // Ensure price is a valid number
    final double? price = double.tryParse(priceText);

    if (coffeeTitle.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and price')),
      );
      return;
    }

    try {
      // Send data to Firestore
      await _firestore.collection('coffee').add({
        'coffee_title': coffeeTitle,
        'price': price,
        'category': 'Signature Drinks',
        'available': true,
      });

      // Show success message and clear fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coffee item added successfully')),
      );
      coffeeTitleController.clear();
      priceController.clear();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coffee Item'),
        backgroundColor: const Color(0xFFA57C50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: coffeeTitleController,
              decoration: const InputDecoration(
                labelText: "Enter Coffee Title",
                prefixIcon: Icon(Icons.coffee),
                labelStyle: TextStyle(color: Colors.black),
                prefixIconColor: Colors.black,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Price",
                prefixIcon: Icon(Icons.monetization_on),
                labelStyle: TextStyle(color: Colors.black),
                prefixIconColor: Colors.black,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addCoffeeItem(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA57C50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Send", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
