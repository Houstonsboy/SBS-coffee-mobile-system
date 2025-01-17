import 'package:coffee_system/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../MainDashboardwidgets/dashboard.dart';
import 'global.dart';  // Import the global.dart file

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginForm({Key? key}) : super(key: key);

  Future<void> login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    try {
      // Firebase authentication logic
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID after login
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Store the userId globally
        globalUserId = user.uid;

        // Log the userId to the terminal
        print('Logged in userId: $globalUserId');

        // Redirect to Dashboard on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        print('No user found after login.');
      }
    } catch (e) {
      // Display error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Enter Email Address",
            prefixIcon: Icon(Icons.email),
            labelStyle: TextStyle(color: Colors.black),
            prefixIconColor: Colors.black,
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Enter Password",
            prefixIcon: Icon(Icons.lock),
            labelStyle: TextStyle(color: Colors.black),
            prefixIconColor: Colors.black,
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => login(context), // Call login function
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA57C50),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text("Sign in", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
