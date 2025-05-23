import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

import '../../home_screen.dart';
import '../../profile/profile_page.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _blurAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _showMessage(context, 'Logged out successfully');
      // Navigate back to login screen after logout if needed
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      _showMessage(context, 'Error Logging out: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: -280, end: 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(value, 0),
                  child: child,
                );
              },
              child: SizedBox(
                width: 280,
                height: 300,
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildHeader(),
                      _buildMenuItem(
                        icon: Icons.home,
                        title: 'HOME',
                        onTap: () => _navigateTo(context, const HomeScreen()),
                      ),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'PROFILE',
                        onTap: () => _navigateTo(context, const ProfilePage()),
                      ),
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'LOGOUT',
                        onTap: () => signOut(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 108,
      child: Stack(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 30.0, top: 20.0),
            child: const Text(
              'MENU',
              style: TextStyle(
                fontFamily: "jura",
                letterSpacing: 6,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 13,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => _animationController.reverse().then((_) {
                Navigator.of(context).pop();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 12, 12, 12)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 17, 16, 16),
            fontFamily: "Jura",
            fontWeight: FontWeight.bold,
            letterSpacing: 2.6,
          ),
        ),
        onTap: () => _animationController.reverse().then((_) => onTap()),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
