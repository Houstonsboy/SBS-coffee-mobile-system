// lib/firebase/orders.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> fetchCoffeeName() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('coffee')
        .where('price', isEqualTo: 200)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      return document['coffee_title'];
    } else {
      return 'No Coffee Found';
    }
  } catch (e) {
    print('Error fetching document: $e');
    return 'Error fetching data';
  }
}
