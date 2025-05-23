import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';
import 'register.dart';
import 'auth_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  bool _isLoading = false;

  void _showSuccessDialog(String title, String message, VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: onOkPressed,
            child: const Text("OK", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        setState(() => _isLoading = false);

        _showSuccessDialog(
          'Success',
          'Login successful!',
          () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? 'Login failed.';
        _isLoading = false;
      });
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController _resetEmailController = TextEditingController();
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Forgot Password", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: _dialogFormKey,
          child: TextFormField(
            controller: _resetEmailController,
            decoration: const InputDecoration(
              labelText: "Enter your registered email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_dialogFormKey.currentState?.validate() != true) return;
              final email = _resetEmailController.text.trim();

              try {
                await _auth.sendPasswordResetEmail(email: email);
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset email sent to $email')),
                );
              } on FirebaseAuthException catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.message}')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('An unexpected error occurred')),
                );
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'BSAFE',
                  style: TextStyle(
                    fontFamily: 'jura',
                    fontSize: 50,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 7, 7, 7),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              letterSpacing: 8,
                              fontFamily: 'Jura',
                              fontSize: 53,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 15, 15, 15),
                            ),
                          ),
                          const SizedBox(height: 40),
                          AuthTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            validator: (value) => value!.isEmpty ? 'Enter valid email' : null,
                          ),
                          AuthTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: true,
                            validator: (value) => value!.isEmpty ? 'Enter password' : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AuthButton(text: 'LOGIN', onPressed: _login),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            ),
                            child: const Text(
                              "Don't have an account? Register",
                              style: TextStyle(color: Color.fromARGB(255, 18, 17, 17)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_message.isNotEmpty)
                            Text(
                              _message,
                              style: const TextStyle(fontFamily: 'Jura', fontSize: 16, color: Colors.red),
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
