import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dashboard.dart';

// Initialize Firebase before running the app
// async is used because Firebase initialization is an asynchronous operation
void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Launch the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Main body of the app
        body: Column(
          children: [
            // Firebase Data Section
            Container(
              padding: const EdgeInsets.all(16.0),
              // FutureBuilder is a widget that builds itself based on the latest snapshot
              // of interaction with a Future (async operation)
              child: FutureBuilder(
                // Call the async function that fetches Firestore data
                future: _fetchDocumentWithPrice(),
                // Builder function that handles different states of the Future
                builder: (context, snapshot) {
                  // Handle different states of the async operation
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading spinner while waiting for data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message if something went wrong
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // If we have data, display it
                    String name = snapshot.data as String;
                    return Text(
                      'Item name: $name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    // If no data matches our query
                    return const Text('No items found with price = 200.');
                  }
                },
              ),
            ),
            // Dashboard Section - takes remaining space
            Expanded(
              child: dashboard(),
            ),
          ],
        ),
        // Bottom Navigation Bar with notched design
        bottomNavigationBar: BottomAppBar(
          notchMargin: 6.0, // Space between FAB and BottomAppBar
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Navigation buttons
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  // Home navigation logic
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Favorites navigation logic
                },
              ),
              const SizedBox(width: 48), // Space for Floating Action Button
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Profile navigation logic
                },
              ),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Menu navigation logic
                },
              ),
            ],
          ),
        ),
        // Floating Action Button in the center of bottom bar
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // FAB action logic
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // Async function to fetch data from Firestore
  // Future<String?> means this function will eventually return a String or null
  Future<String?> _fetchDocumentWithPrice() async {
    try {
      // Query Firestore for documents where price equals 200
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coffee')
          .where('price', isEqualTo: 200)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        return document['name']; // Return the 'name' field from the document
      } else {
        return null; // Return null if no documents found
      }
    } catch (e) {
      // Log any errors that occur during the fetch
      print('Error fetching document: $e');
      return null;
    }
  }
}
