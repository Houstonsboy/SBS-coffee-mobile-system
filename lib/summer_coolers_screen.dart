import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SummerCoolersScreen extends StatefulWidget {
  const SummerCoolersScreen({Key? key}) : super(key: key);

  @override
  State<SummerCoolersScreen> createState() => _SummerCoolersScreenState();
}

class _SummerCoolersScreenState extends State<SummerCoolersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _summerCoolers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummerCoolers();
  }

  Future<void> _fetchSummerCoolers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('coffee')
          .where('category', isEqualTo: 'Summer Coolers')
          .get();

      List<Map<String, dynamic>> fetchedCoolers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for updates
        return data;
      }).toList();

      setState(() {
        _summerCoolers = fetchedCoolers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Summer Coolers: $e');
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
        title: const Text('Summer Coolers'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summerCoolers.isEmpty
              ? const Center(
                  child: Text(
                    'No Summer Coolers available!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _summerCoolers.length,
                  itemBuilder: (context, index) {
                    final cooler = _summerCoolers[index];
                    bool isAvailable = cooler['available'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          cooler['coffee_title'] ?? 'Unknown Title',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Ksh ${cooler['price'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isAvailable,
                                  onChanged: (value) {
                                    setState(() {
                                      _summerCoolers[index]['available'] =
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
                                cooler['id'], isAvailable); // Update Firebase
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
