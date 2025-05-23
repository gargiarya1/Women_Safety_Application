import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({super.key});

  Future<void> openMap(String location) async {
    Uri url = Uri.parse("https://www.google.com/maps/search/$location");
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading");
    }
  }

  Widget buildCard({
    required String imagePath,
    required String title,
    required String location,
  }) {
    return InkWell(
      onTap: () {
        openMap(location);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFF75874), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        openMap(location);
                      },
                      child: const Icon(
                        Icons.directions,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LiveSafe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: 5, // Number of items in the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // crossAxisSpacing: ,
                  // mainAxisSpacing: 12,
                  childAspectRatio: 0.8, // Adjust as necessary
                ),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return buildCard(
                        imagePath: "assets/safe_place/police_place.png",
                        title: "Police Station",
                        location: 'Police Stations near me',
                      );
                    case 1:
                      return buildCard(
                        imagePath: "assets/safe_place/hospital_place.png",
                        title: "Hospitals",
                        location: 'Hospitals near me',
                      );
                    case 2:
                      return buildCard(
                        imagePath: "assets/safe_place/bus_place.png",
                        title: "Bus Station",
                        location: 'Bus Stations near me',
                      );
                    case 3:
                      return buildCard(
                        imagePath: "assets/safe_place/clinic_place.png",
                        title: "Medicals",
                        location: 'Medicals near me',
                      );
                    case 4:
                      return buildCard(
                        imagePath: "assets/safe_place/hotel_place.png",
                        title: "Hotels",
                        location: 'Hotels near me',
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
