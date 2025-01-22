import 'package:coffee_system/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global.dart';
class LoginForm extends StatefulWidget {

  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  Future<void> login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    try {
      // Firebase authentication logic
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user details
      final User? user = userCredential.user;
      final String userId = user?.uid ?? '';
      final String useremail = user?.email ?? '';


      // Save userId and username globally
      globalUserId = userId;
      globalEmail = useremail;

      // Redirect to Dashboard on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
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
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: "Enter Password",
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              ),
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
