import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 237, 66, 126),
      title: Text(
        title,
        style: const TextStyle(
          height: 6,
          letterSpacing: 3,
          fontFamily: 'jura',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      // actions: [
      //   IconButton(
      //     icon: const Icon(
      //       Icons.shopping_bag_outlined,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => CartPage(), // Replace with your CartPage widget
      //         ),
      //       );
      //     },
      //   ),
      // ],
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}