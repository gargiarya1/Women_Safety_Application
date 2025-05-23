// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:safe/screens/sos_screen.dart';

// class SOSButton extends StatelessWidget {
//   const SOSButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       // Use Column to allow Expanded to work properly
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () {
//             debugPrint("SOS button pressed");
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (ctx) => const AlertMessageScreen()),
//             );
//           },
//           child: Container(
//             width: 230.0,
//             height: 230.0,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const RadialGradient(
//                 colors: [Colors.white, Colors.pinkAccent],
//                 center: Alignment.center,
//                 radius: 0.8,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   spreadRadius: 4,
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Container(
//                 width: 200.0,
//                 height: 200.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.pink,
//                   border: Border.all(color: Colors.white, width: 4),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'SOS',
//                     style: GoogleFonts.arimo(
//                       color: Colors.white,
//                       fontSize: 66.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20), // Add spacing if needed
//         Expanded(
//           // Example of using Expanded correctly
//           child: Container(
//             color: Colors.grey[200],
//             child: Center(
//               child: Text(
//                 'Additional Content Here',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
