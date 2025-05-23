import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/components/custom_button.dart';
import 'package:safe/screens/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class AlertMessageScreen extends StatefulWidget {
  const AlertMessageScreen({super.key});

  @override
  _AlertMessageScreenState createState() => _AlertMessageScreenState();
}

class _AlertMessageScreenState extends State<AlertMessageScreen> {
  final TextEditingController textController = TextEditingController();
  final LocationService _locationService = LocationService();
  static const platform = MethodChannel('com.example.sos/sms');

  String locationMessage = "Fetching location...";
  String mapLink = "";
  List<String> contactNumbers = [];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchContacts();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      String address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, \nLongitude: ${position.longitude}\nAddress: $address";
        mapLink =
            'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = "Failed to fetch location: ${e.toString()}";
      });
    }
  }

  Future<void> _fetchContacts() async {
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

  Future<void> _sendSMSWithPlatformChannel() async {
    if (contactNumbers.isEmpty) {
      Fluttertoast.showToast(msg: "No contacts to send alerts to.");
      return;
    }

    var permission = await Permission.sms.status;
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
      if (!permission.isGranted) {
        Fluttertoast.showToast(msg: "SMS permission denied");
        return;
      }
    }

    final String message =
        "${textController.text}\nLocation: $mapLink";

    try {
      await platform.invokeMethod('sendSMS', {
        'recipients': contactNumbers,
        'message': message,
      });
      Fluttertoast.showToast(msg: "Opening SMS app...");
    } on PlatformException catch (e) {
      debugPrint("Platform error: ${e.message}");
      Fluttertoast.showToast(msg: "Failed to send SMS.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Alert Message',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter your emergency message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Text(
              locationMessage,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Send Alert",
              onPressed: _sendSMSWithPlatformChannel,
            ),
          ],
        ),
      ),
    );
  }
}
