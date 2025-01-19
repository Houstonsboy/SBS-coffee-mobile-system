import 'package:coffee_system/AuthHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'Authentication/auth_screen.dart';
import 'Authentication/global.dart';
import 'navigation/addcoffee.dart';
import 'main_screen.dart';
import 'user/UserProvider.dart';
import 'Authentication/global.dart';

// Initialize Firebase before running the app
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await loadGlobalVariables();

  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  runApp(
    ChangeNotifierProvider(
    create: (_) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkLogin();
    initialization();
  }

  //splashscreen
  void initialization() async {
    print('showing splash');
    await Future.delayed(const Duration(seconds: 2));
    print('removing splash');
    FlutterNativeSplash.remove();
  }

  //check if already logged in
  var auth = FirebaseAuth.instance;
  checkLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isUserLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthHandler(),
    );
  }
}
