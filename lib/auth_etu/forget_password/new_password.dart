import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../composants/Button.dart';
import '../../composants/textField.dart';
import '../../theme/style.dart';
import '../login.dart';
import 'package:dio/dio.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});
  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();// Corrected
  final _formKey = GlobalKey<FormState>();

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? true) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Les mots de passe ne correspondent pas")),
        );
        return;
      }

      final Dio dio = Dio();

      try {
        final response = await dio.post(
          '',
          data: {
            // Corrected
            'current_password': _newPasswordController.text,
            'new_password': _confirmPasswordController.text,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          Get.snackbar(
            "Succès",
            "Mot de passe modifié avec succès!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: KColors.primary,
            colorText: Colors.white,
          );
          Get.to(Login()); // Redirection vers la page de login après succès
        } else {
          Get.snackbar(
            "Erreur",
            "Échec de la réinitialisation du mot de passe : ${response.data}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Erreur",
          "Échec de la réinitialisation du mot de passe : ${e.toString()}",
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
      appBar: AppBar(title: const Text("Nouveau mot de passe")),
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
                  Textfield(
                    controller: _newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      } else if (!isValidPassword(value)) {
                        return 'Mot de passe trop faible (8 caractères, 1 majuscule, 1 chiffre)';
                      }
                      return null;
                    },
                    name: 'Entrez un nouveau mot de passe',
                  ),
                  const SizedBox(height: 20),
                  Textfield(
                    controller: _confirmPasswordController,
                    name: "Confirmer le mot de passe",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer le mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: _resetPassword,
                    child: const Text("Terminer"),
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
