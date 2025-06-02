import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../composants/Button.dart';
import '../../composants/textField.dart';
import '../../theme/style.dart';
import 'new_password.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  // Fonction de réinitialisation de mot de passe sans Firebase


  Future<void> _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      final Dio dio = Dio();

      try {
        final response = await dio.post(
          'http://192.168.100.192:8000/api/forgot-password',
          data: {
            'email': _emailController.text,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        setState(() {
          isLoading = false;
        });

        if (response.statusCode == 200) {
          Get.snackbar(
            "Succès",
            "Un e-mail de réinitialisation a été envoyé à ${_emailController.text}.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: KColors.primary,
            colorText: Colors.white,
          );
          Get.to(NewPasswordPage()); // Redirection vers la page de login après succès
        } else {
          Get.snackbar(
            "Erreur",
            "Impossible d'envoyer l'e-mail : ${response.data}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });

        Get.snackbar(
          "Erreur",
          "Impossible d'envoyer l'e-mail : ${e.toString()}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Réinitialisation du mot de passe")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/Tiny house-bro.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Entrez votre email pour réinitialiser votre mot de passe",
                    style: KTypography.h4(context, color: KColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Textfield(
                    controller: _emailController,
                    name: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      } else if (!isValidEmail(value)) {
                        return 'Format d\'email invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Button(
                    onPressed: () =>Get.to(NewPasswordPage()),//_sendResetLink,
                    child: const Text("Continuer"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
