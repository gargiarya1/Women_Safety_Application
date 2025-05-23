import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe/screens/auth/login.dart';
import 'package:safe/screens/home/widgets/bottom_nav_bar.dart';
import 'package:safe/screens/home/widgets/common_appbar.dart';
import 'package:safe/screens/home/widgets/common_drawer.dart';
import 'package:safe/screens/home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          name = data?['name'] ?? 'Rita Smith';
        });
      } else {
        setState(() {
          name = 'Rita Smith';
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _showMessage('Logged out successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      _showMessage('Error Logging out: $e');
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
      child: SafeArea(
        child: Scaffold(
          appBar: CommonAppBar(title: 'PROFILE'),
          drawer: CommonDrawer(),
          backgroundColor: const Color.fromARGB(255, 250, 249, 249),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 163, 158, 160)
                                    .withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 60, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          name.isNotEmpty ? name : 'Loading...',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 7, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 42, 41, 41),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      color: Color.fromARGB(179, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 74, 74, 74),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.email, color: Colors.white70),
                                  SizedBox(width: 16),
                                  Text('Email',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Text(email,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 72, 72, 72),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildAccountTile(Icons.logout, 'Log out', signOut,
                            iconColor: Colors.pink, textColor: Colors.pink),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CommonBottomNavBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTile(IconData icon, String title, VoidCallback onTap,
      {Color iconColor = Colors.white70, Color textColor = Colors.white}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 16),
                Text(title, style: TextStyle(color: textColor)),
              ],
            ),
            Icon(Icons.chevron_right, color: iconColor.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}
