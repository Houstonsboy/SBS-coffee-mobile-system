import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassicDrinksScreen extends StatefulWidget {
  const ClassicDrinksScreen({Key? key}) : super(key: key);

  @override
  State<ClassicDrinksScreen> createState() => _ClassicDrinksScreenState();
}

class _ClassicDrinksScreenState extends State<ClassicDrinksScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _classicDrinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClassicDrinks();
  }

  Future<void> _fetchClassicDrinks() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('coffee')
          .where('category', isEqualTo: 'Classic Drinks')
          .get();

      List<Map<String, dynamic>> fetchedDrinks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for updates
        return data;
      }).toList();

      setState(() {
        _classicDrinks = fetchedDrinks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Classic Drinks: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAvailability(String id, bool isAvailable) async {
    try {
      await _firestore.collection('coffee').doc(id).update({
        'available': isAvailable,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability updated for item $id')),
      );
    } catch (e) {
      print('Error updating availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update availability')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic Drinks'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _classicDrinks.isEmpty
              ? const Center(
                  child: Text(
                    'No Classic Drinks available!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _classicDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = _classicDrinks[index];
                    bool isAvailable = drink['available'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          drink['coffee_title'] ?? 'Unknown Title',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Ksh ${drink['price'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isAvailable,
                                  onChanged: (value) {
                                    setState(() {
                                      _classicDrinks[index]['available'] =
                                          value!;
                                    });
                                  },
                                ),
                                const Text('Mark as Available'),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _updateAvailability(
                                drink['id'], isAvailable); // Update Firebase
                          },
                          child: const Text('Update'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
