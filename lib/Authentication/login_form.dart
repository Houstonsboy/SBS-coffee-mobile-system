import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: "Enter Email Address",
            prefixIcon: Icon(Icons.email),
            labelStyle: TextStyle(color: Colors.black),
            prefixIconColor: Colors.black,
          ),
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 10),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Enter Password",
            prefixIcon: Icon(Icons.lock),
            labelStyle: TextStyle(color: Colors.black),
            prefixIconColor: Colors.black,
          ),
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement login logic
          },
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
