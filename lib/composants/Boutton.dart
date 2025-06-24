import 'package:flutter/material.dart';

import '../style.dart';

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor; // Couleur de fond du conteneur
  final Color borderColor;
  final Color foregroundColor;

  Button({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor = KColors.primary, // Utilisez la couleur primaire par défaut
    this.borderColor = KColors.primary, // Utilisez la couleur primaire par défaut
    this.foregroundColor = Colors.white, // Valeur par défaut pour la couleur du texte
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        elevation: 2,
        side: BorderSide(color: borderColor, width: 1),
        textStyle: KTypography.h6(context, color: foregroundColor), // Utilisez le style de texte défini
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(250, 40), // Taille minimale du bouton
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Padding
      ),
    );
  }
}
