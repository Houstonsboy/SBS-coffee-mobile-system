import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({Key? key}) : super(key: key);

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _signatures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSignatures();
  }

  Future<void> _fetchSignatures() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('coffee')
          .where('category', isEqualTo: 'Signatures')
          .get();

      List<Map<String, dynamic>> fetchedSignatures = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for updates
        return data;
      }).toList();

      setState(() {
        _signatures = fetchedSignatures;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Signatures: $e');
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
        title: const Text('Signatures'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _signatures.isEmpty
              ? const Center(
                  child: Text(
                    'No Signatures available!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _signatures.length,
                  itemBuilder: (context, index) {
                    final signature = _signatures[index];
                    bool isAvailable = signature['available'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          signature['coffee_title'] ?? 'Unknown Title',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Ksh ${signature['price'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: isAvailable,
                                  onChanged: (value) {
                                    setState(() {
                                      _signatures[index]['available'] = value!;
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
                            _updateAvailability(signature['id'],
                                isAvailable); // Update Firebase
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
