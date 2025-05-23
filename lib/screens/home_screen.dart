import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe/screens/emergency_screen.dart';
import 'package:safe/screens/feed_screen.dart';
import 'package:safe/screens/location_screen.dart';
import 'package:safe/screens/sos_screen.dart';
import 'package:safe/screens/profile/profile_page.dart';
import 'package:safe/screens/home/widgets/bottom_nav_bar.dart';
import 'package:safe/screens/home/widgets/common_appbar.dart';
import 'package:safe/screens/home/widgets/common_drawer.dart';
import 'package:safe/widgets/contacts/contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
    // You can add more logic for other indices if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'bSafe'),
      drawer: const CommonDrawer(),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("SOS button pressed");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AlertMessageScreen()),
                );
              },
              child: Container(
                width: 230.0,
                height: 230.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Colors.white, Colors.pinkAccent],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        'SOS',
                        style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontSize: 66.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                _buildGridItem(
                  context,
                  title: 'Share Location',
                  image: 'assets/share_location.png',
                  gradientColors: [const Color(0xFFffc94f), const Color(0xFFfd7d08)],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const LocationScreen()),
                  ),
                ),
                _buildGridItem(
                  context,
                  title: 'Emergency',
                  image: 'assets/emergency.png',
                  gradientColors: [const Color(0xFF27fcb3), const Color(0xFF0cc291)],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const EmergencyScreen()),
                  ),
                ),
                _buildGridItem(
                  context,
                  title: 'Contacts',
                  image: 'assets/contacts.png',
                  gradientColors: [
                    const Color.fromARGB(255, 216, 131, 215),
                    const Color(0xFFf56ca6)
                  ],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const ContactsScreen()),
                  ),
                ),
                _buildGridItem(
                  context,
                  title: 'Feed',
                  image: 'assets/feed.png',
                  gradientColors: [const Color(0xFF80D0C7), const Color(0xFF0093E9)],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const FeedScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required String title,
    required String image,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFFebadff),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(image, fit: BoxFit.cover, height: 130, width: 130),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
