import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
        themeMode: ThemeMode.light,

        //*TextTheme
        theme: ThemeData(
          //!Title
          //# Title Large
          textTheme: GoogleFonts.firaSansTextTheme().copyWith(
            bodyMedium: GoogleFonts.arimoTextTheme().titleLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
            labelSmall: GoogleFonts.arimoTextTheme().titleLarge!.copyWith(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        //
        debugShowCheckedModeBanner: false,
        //
        home: const SplashScreen());
  }
}
