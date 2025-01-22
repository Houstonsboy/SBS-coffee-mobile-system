import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinterWarmersScreen extends StatefulWidget {
  const WinterWarmersScreen({Key? key}) : super(key: key);

  @override
  State<WinterWarmersScreen> createState() => _WinterWarmersScreenState();
}

class _WinterWarmersScreenState extends State<WinterWarmersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _winterWarmers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWinterWarmers();
  }

  Future<void> _fetchWinterWarmers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('coffee')
          .where('category', isEqualTo: 'Winter Warmers')
          .get();

      List<Map<String, dynamic>> fetchedWarmers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for updates
        return data;
      }).toList();

      setState(() {
        _winterWarmers = fetchedWarmers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Winter Warmers: $e');
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
        title: const Text('Winter Warmers'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _winterWarmers.isEmpty
              ? const Center(
                  child: Text(
                    'No Winter Warmers available!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _winterWarmers.length,
                  itemBuilder: (context, index) {
                    final warmer = _winterWarmers[index];
                    bool isAvailable = warmer['available'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          warmer['coffee_title'] ?? 'Unknown Title',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Ksh ${warmer['price'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isAvailable,
                                  onChanged: (value) {
                                    setState(() {
                                      _winterWarmers[index]['available'] =
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
                                warmer['id'], isAvailable); // Update Firebase
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
