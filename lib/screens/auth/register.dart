import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_screen.dart';
import 'login.dart';
import 'auth_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _message = '';
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _message = 'Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
          'email': _emailController.text.trim(),
        });
      }

      setState(() => _isLoading = false);

      _showSuccessDialog(
        'Success',
        'Registration successful! Please log in.',
        () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? 'Registration failed.';
        _isLoading = false;
      });
    }
  }

  Future<void> _googleSignUpMethod() async {
    setState(() => _isLoading = true);

    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _message = 'Google Sign-In was canceled.';
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'name': googleUser.displayName ?? 'New User',
            'email': googleUser.email,
          });
        }
      }

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
    } catch (e) {
      setState(() {
        _message = 'Google Sign-In Error: ${e.toString()}';
        _isLoading = false;
      });
    }
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
                            'REGISTER',
                            style: TextStyle(
                              letterSpacing: 8,
                              fontFamily: 'Jura',
                              fontSize: 53,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 15, 15, 15),
                            ),
                          ),
                          const SizedBox(height: 40),
                          AuthTextField(controller: _firstNameController, labelText: 'First Name', validator: (value) => value!.isEmpty ? 'Required' : null),
                          AuthTextField(controller: _lastNameController, labelText: 'Last Name', validator: (value) => value!.isEmpty ? 'Required' : null),
                          AuthTextField(controller: _emailController, labelText: 'Email', validator: (value) => value!.isEmpty ? 'Enter valid email' : null),
                          AuthTextField(controller: _passwordController, labelText: 'Password', obscureText: true, validator: (value) => value!.length < 6 ? 'Min 6 chars' : null),
                          AuthTextField(controller: _confirmPasswordController, labelText: 'Confirm Password', obscureText: true, validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null),
                          const SizedBox(height: 20),
                          AuthButton(text: 'REGISTER', onPressed: _register),
                          const SizedBox(height: 10),
                          AuthButton(text: 'SIGN IN WITH GOOGLE', onPressed: _googleSignUpMethod),
                          const SizedBox(height: 50),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                            child: const Text('Already have an account? Login', style: TextStyle(color: Color.fromARGB(255, 18, 17, 17))),
                          ),
                          const SizedBox(height: 20),
                          Text(_message, style: const TextStyle(fontFamily: 'Jura', fontSize: 16, color: Color.fromARGB(255, 11, 11, 11))),
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
