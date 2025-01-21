import 'package:coffee_system/AuthHandler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'navigation/dashboard.dart';
import 'navigation/homepage.dart';
import 'Authentication/auth_screen.dart';
import  'Authentication/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navigation/addcoffee.dart';
import 'navigation/profile.dart';

import 'user/UserProvider.dart';


// Initialize Firebase before running the app
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future.delayed(const Duration(seconds: 2), (){
    FlutterNativeSplash.remove();
  });
    
    

  runApp(ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MyApp(),
    ));
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
      debugShowCheckedModeBanner: false,
      home: AuthHandler(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }
  void initialization() async{
    print('showing splash');
    await Future.delayed(const Duration(seconds: 2));
    print('removing splash');
    FlutterNativeSplash.remove();
  }
  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // List of widgets corresponding to each tab
  final List<Widget> _pages = [
    const HomePage(),
    dashboard(),
    AddCoffeeItem(),
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
