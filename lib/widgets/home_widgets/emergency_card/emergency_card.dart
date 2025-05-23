import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe/data/emergency_list.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 260,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: emergencyList.length,
                itemBuilder: (ctx, index) {
                  final emergency = emergencyList[index];
                  return InkWell(
                    onTap: () {
                      _makeCall(emergency.number);
                    },
                    child: EmergencyItem(emergency: emergency),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeCall(String number) async {
    if (number.isEmpty || int.tryParse(number) == null) {
      print('Invalid phone number: $number');
      return;
    }

    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        print('Phone permission not granted');
        return;
      }
    }

    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print('Error making call: $e');
    }
  }
}

class EmergencyItem extends StatelessWidget {
  final dynamic emergency;

  const EmergencyItem({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 328,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf56ca6),
              Color(0xFFebadff),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(emergency.avtar),
                ),
                const SizedBox(width: 10),
                Text(
                  emergency.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              emergency.info,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _makeCall(emergency.number);
              },
              child: Text(
                emergency.number,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeCall(String number) async {
    if (number.isEmpty || int.tryParse(number) == null) {
      print('Invalid phone number: $number');
      return;
    }

    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        print('Phone permission not granted');
        return;
      }
    }

    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print('Error making call: $e');
    }
  }
}
