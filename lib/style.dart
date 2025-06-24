import 'package:flutter/material.dart';

class KColors {
  static const Color primary = Color(0xFF0B0A5C); // Bleu foncé
  static const Color secondary = Color(0xFF575992);
  static const Color tertiary = Color(0xFF305870); // bleu gris
  static const Color purple = Color(0xFF7A68A6); // violet
  static const Color beige = Color(0xFFF7EAD0); // beige clair
}

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: KColors.primary,
    fontFamily: 'Poppins', // Définir la police par défaut
    colorScheme: ColorScheme.light(
      primary: KColors.primary,
      secondary: KColors.secondary,
      tertiary: KColors.tertiary,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: KColors.primary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: KColors.secondary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: KColors.tertiary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: KColors.primary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
  );
}

class KTypography {
  static TextStyle h1(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(color: color);
  }

  static TextStyle h2(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(color: color);
  }

  static TextStyle h3(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(color: color);
  }

  static TextStyle h4(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: color);
  }

  static TextStyle h5(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(color: color);
  }

  static TextStyle h6(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(color: color);
  }
}
