import 'package:flutter/material.dart';
import 'package:safe/widgets/home_widgets/emergency_card/emergency_card.dart';
import 'package:safe/widgets/home_widgets/live_safe/live_safe.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        
        children: const [
          EmergencyCard(),
          LiveSafe(),
        ],  
      ),
    );
  }
}