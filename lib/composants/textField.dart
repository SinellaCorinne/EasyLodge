import 'package:flutter/material.dart';

import '../theme/style.dart';

class Textfield extends StatelessWidget {
  final String? name;
  final bool obscureText ;
  final TextInputType? keyboardType;
  final bool showClearButton;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final dynamic initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const Textfield({
    super.key,
    required this.name,
    this.obscureText = true,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.initialValue,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      style: KTypography.h6(context, color: Colors.black), // Utilisez le style de texte défini
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: name,
        labelStyle: KTypography.h5(context, color: Colors.black), // Utilisez le style de texte défini
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: showClearButton
            ? Icon(Icons.close, size: 20, color: KColors.primary) // Utilisez la couleur définie
            : suffixIcon,
      ),
    );
  }
}