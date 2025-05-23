import 'package:flutter/material.dart';

import '../../home_screen.dart';
import '../../profile/profile_page.dart';
import '../../chatbot_screen.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CommonBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 235, 65, 136),
      iconSize: 32,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      selectedItemColor: const Color.fromARGB(255, 8, 8, 8),
      unselectedItemColor: const Color.fromARGB(255, 252, 251, 251),
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ChatbotScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ),
            );
            break;
        }
      },
    );
  }
}
