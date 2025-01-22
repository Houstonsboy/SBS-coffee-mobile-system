// auth_screen.dart
import 'package:flutter/material.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFFEAE0D5),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isLogin)
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2.3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(100),
                                ),
                                child: Image.asset(
                                  'images/coffee2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2.8,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(100),
                                ),
                                child: Image.asset(
                                  'images/Coffee1.jpg',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          Positioned(
                            top: 10,
                            child: Image.asset(
                              'images/SU-Logo.png',
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to Strathmore University\nCoffee Shop",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isLogin
                            ? "Place your order and pick your coffee\nwithin minutes..."
                            : "Create Account",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: _isLogin ? LoginForm() : SignUpForm(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? "If you don't already have an account\nSign-up"
                              : "If you already have an account\nSign-in",
                              textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
