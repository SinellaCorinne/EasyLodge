import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_etu/onboarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App Loge",
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.white70, // Couleur de fond pour toutes les pages
        textTheme: GoogleFonts
            .poppinsTextTheme(), // Utilisez Google Fonts si nécessaire
        // Autres configurations de thème
      ),
      home: Onboarding(),
    );
  }
}
