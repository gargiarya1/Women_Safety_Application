import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? lat;
  double? long;
  String locationMessage = "Fetching location...";
  String address = "Fetching address...";
  String mapLink = "";
  List<String> contactNumbers = [];
  static const platform = MethodChannel('com.example.sos/sms');

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchEmergencyContacts();
  }

  Future<void> _fetchEmergencyContacts() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Fluttertoast.showToast(msg: "User not logged in");
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('Contacts')
          .where('uid', isEqualTo: currentUser.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        Fluttertoast.showToast(msg: "No contacts found");
        return;
      }

      List<String> numbers = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final number = data['Number']?.toString();
        if (number != null && number.isNotEmpty) {
          numbers.add(number);
        }
      }

      setState(() {
        contactNumbers = numbers;
      });

      debugPrint("Fetched contacts: $contactNumbers");
    } catch (e) {
      debugPrint("Error fetching contacts: $e");
      Fluttertoast.showToast(msg: "Error fetching contacts.");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw "Location services are disabled.";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permission denied.";
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw "Location permission is permanently denied.";
      }

      Position position = await Geolocator.getCurrentPosition();
      _updateLocation(position);
      _listenToLocationUpdates();
    } catch (e) {
      setState(() {
        locationMessage = e.toString();
      });
    }
  }

  void _updateLocation(Position position) {
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      locationMessage = "Latitude: $lat \nLongitude: $long";
      _getAddress(lat!, long!);
    });
  }

  void _listenToLocationUpdates() {
    Geolocator.getPositionStream(
            locationSettings: const LocationSettings(distanceFilter: 100))
        .listen(_updateLocation);
  }

  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      setState(() {
        Placemark place = placemarks.reversed.last;
        address = "${place.name}, ${place.subLocality}, ${place.locality}, "
            "${place.administrativeArea}, ${place.country}, ${place.postalCode}";
      });
    } catch (e) {
      setState(() {
        address = "Address not found.";
      });
    }
  }

  Future<void> _openMap() async {
    if (lat != null && long != null) {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$long');
      if (!await launchUrl(url)) {
        Fluttertoast.showToast(msg: "Could not open map.");
      }
    }
  }

  Future<void> _sendLocationToContacts() async {
    if (contactNumbers.isEmpty) {
      Fluttertoast.showToast(msg: "No contacts to send location.");
      return;
    }

    final String message =
        "Emergency! I need help. My location: $mapLink";

    try {
      // Send location to all emergency contacts via SMS
      await platform.invokeMethod('sendSMS', {
        'recipients': contactNumbers,
        'message': message,
      });

      Fluttertoast.showToast(msg: "Location shared with emergency contacts.");
    } catch (e) {
      debugPrint("Error sending SMS: $e");
      Fluttertoast.showToast(msg: "Could not send SMS.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _buildLocationCard(context),
              const SizedBox(height: 16),
              _buildActionButtons(),
              if (lat != null && long != null) _buildMap(),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildLocationCard(BuildContext context) {
    return Card(
      color: const Color(0xFF0093E9),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Location',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              locationMessage,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _openMap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF75874),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
          ),
          child: const Text(
            "Open Map",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            if (lat != null && long != null) {
              mapLink =
                  'https://www.google.com/maps/search/?api=1&query=$lat,$long';
              _sendLocationToContacts();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF75874),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
          ),
          child: const Text(
            "Share Location",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 400,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat!, long!),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
              point: LatLng(lat!, long!),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: const Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
