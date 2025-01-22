import 'package:coffee_system/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'global.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  //final TextEditingController schoolIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //String? selectedGender;

  bool _obscurePassword=true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    //final String schoolId = schoolIdController.text.trim();
    final String password = passwordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        //schoolId.isEmpty ||
        password.isEmpty
        //|| selectedGender == null
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? userId = userCredential.user?.uid;

      // Save user details in Firestore
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'phone': phone,
        //'schoolId': schoolId,
        //'gender': selectedGender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Set global variables
      
        globalUserId = userId;
        globalUsername = username;
        globalEmail = email;
        globalPhone = phone;
        isUserLoggedIn = true;
        await saveGlobalVariables();


      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      // Clear fields
      clearFields();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void clearFields() {
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    //schoolIdController.clear();
    passwordController.clear();
    // setState(() {
    //   selectedGender = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
  	    children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: "Enter Username",
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Enter Email Address",
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: "Enter Phone Number",
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        // const SizedBox(height: 10),
        // TextField(
        //   controller: schoolIdController,
        //   decoration: const InputDecoration(
        //     labelText: "Enter School ID",
        //     prefixIcon: Icon(Icons.school),
        //   ),
        // ),
        // const SizedBox(height: 10),
        // DropdownButtonFormField<String>(
        //   value: selectedGender,
        //   decoration: const InputDecoration(
        //     labelText: "Select Gender",
        //     prefixIcon: Icon(Icons.person_outline),
        //   ),
        //   items: const [
        //     DropdownMenuItem(value: "Male", child: Text("Male")),
        //     DropdownMenuItem(value: "Female", child: Text("Female")),
        //     DropdownMenuItem(value: "Prefer not to say", child: Text("Prefer not to say")),
        //   ],
        //   onChanged: (value) {
        //     setState(() {
        //       selectedGender = value;
        //     });
        //   },
        // ),
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
              )
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => signUp(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA57C50), // Button color
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
          ),
          child: const Text(
            "Sign up",
            style: TextStyle(color: Colors.white),
            ),
        ),
      ],
      ),
    );
  }
}
