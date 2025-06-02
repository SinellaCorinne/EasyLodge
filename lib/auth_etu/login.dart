import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/auth_etu/forget_password/forgot_password.dart';
import 'package:loge_app/composants/profil_user.dart';
import 'package:loge_app/pages/ecrans/etudiant/composants/loge_page.dart';
import '../composants/Button.dart';
import '../composants/textField.dart';
import '../pages/ecrans/bailleurs/composants/baill_page.dart';
import '../theme/style.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();
  bool isLoading = false;
  String? responseText;

  Future<void> login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      isLoading = true;
      responseText = null;
    });

    try {
      final response = await dio.post(
        '', // 🔁 Mets ici ta vraie URL
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final role = data['role_user'];
        final email = data['email'] ?? emailController.text;
        final message = data['message'] ?? 'Connexion réussie';

        setState(() {
          responseText = "Bienvenue $email\n$message";
          isLoading = false;
        });

        // Redirection selon le rôle
        if (role == 'etudiant') {
          Get.off(() => LogePage());
        } else if (role == 'bailleur') {
          Get.off(() => BaillPage());
        } else {
          Get.snackbar('Erreur', 'Rôle inconnu');
        }
      } else {
        throw Exception('Réponse inattendue du serveur');
      }
    } catch (e) {
      setState(() {
        responseText = "Erreur : ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/Tiny house-bro.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    Text("Connectez-vous",
                        style: KTypography.h3(context, color: KColors.primary),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Textfield(
                      controller: emailController,
                      name: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un email';
                        } else if (!isValidEmail(value)) {
                          return 'Format d\'email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Textfield(
                      controller: passwordController,
                      name: "Mot de passe",
                      suffixIcon: Icon(Iconsax.password_check, color: KColors.primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        } else if (!isValidPassword(value)) {
                          return 'Le mot de passe doit contenir au moins 8 caractères, une lettre majuscule et un chiffre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      child: Text("Mot de passe oublié ?",
                          style: KTypography.h6(context, color: KColors.primary)),
                      onPressed: () => Get.to(() => ForgotPassword()),
                    ),
                    const SizedBox(height: 10),
                    if (isLoading)
                      CircularProgressIndicator(color: KColors.primary)
                    else
                      Button(
                        child: Text("Se connecter"),
                        onPressed: () => Get.to(() => LogePage()),//login,
                        backgroundColor: KColors.primary,
                        borderColor: KColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    const SizedBox(height: 10),
                    Button(
                      child: Text("S'inscrire"),
                      onPressed: () => Get.to(() => ProfilUser()),
                      backgroundColor: Colors.white,
                      borderColor: KColors.primary,
                      foregroundColor: KColors.primary,
                    ),
                    if (responseText != null) ...[
                      const SizedBox(height: 15),
                      Text(
                        responseText!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }
}
