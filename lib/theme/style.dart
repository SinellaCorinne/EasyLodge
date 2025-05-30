// Couleurs du thème
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
class KColors {
  static const Color primary = Color(0xFF0B0A5C); // Bleu foncé
  static const Color secondary = Color(0XFFb21f1f); // Vert
  static const Color tertiary = Color(0xFF305870); // bleu gris
  static const Color Purple = Color(0xFF7A68A6); // violet
  static const Color beige = Color(0xFFF7EAD0); // beige clair
}

// Thème de l'application
ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: KColors.primary,
    colorScheme: ColorScheme.light(
      primary: KColors.primary,
      secondary: KColors.secondary,
      tertiary: KColors.tertiary,
    ),
    textTheme: TextTheme(
      headlineLarge: KTypography.h1(context),
      headlineMedium: KTypography.h2(context),
      headlineSmall: KTypography.h3(context),
      bodyLarge: KTypography.h4(context),
      bodyMedium: KTypography.h5(context),
    ),
    // Ajoutez d'autres propriétés de thème ici
  );
}

class KTypography {
  static TextStyle h1(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h2(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h3(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .headlineSmall!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h4(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle h5(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.normal, color: color);
  }

  static TextStyle h6(BuildContext context, {Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.normal, color: color);
  }
}
