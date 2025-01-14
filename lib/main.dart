import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'homepage/homepage.dart';
import 'Authentication/auth_screen.dart';

// Initialize Firebase before running the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strathmore Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const AuthScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // List of widgets corresponding to each tab
  final List<Widget> _pages = [
    const HomePage(),
    dashboard(),
    const Center(child: Text('Receipts Page')),
    const Center(child: Text('Profile Page')),
  ];

  // Function to fetch data from Firestore
  Future<String?> _fetchDocumentWithPrice() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coffee')
          .where('price', isEqualTo: 200)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        return document['name'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee System'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Dynamically change the body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current active tab
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Receipts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
