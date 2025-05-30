// connexion_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/composants/profil_user.dart';
import 'package:loge_app/pages/ecrans/etudiant/composants/loge_page.dart';
import '../composants/Button.dart';
import '../composants/textField.dart';
import '../theme/style.dart';
import 'onboarding.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
              child: Padding(
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
                      SizedBox(height: 40),
                      Text("Connectez vous",
                          style: KTypography.h3(context, color: KColors.primary),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20),
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
                          return null; // Pas d'erreur
                        },
                      ),
                      SizedBox(height: 15),
                      Textfield(
                        controller: passwordController,
                        name: "Password",
                        suffixIcon: Icon(Iconsax.password_check,
                            color: KColors.primary),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          } else if (!isValidPassword(value)) {
                            return 'Le mot de passe doit contenir au moins 8 caractères, une lettre majuscule et un chiffre';
                          }
                          return null; // Pas d'erreur
                        },
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        child: Text("Mot de passe oublié?",
                            style: KTypography.h6(context,
                                color: KColors.primary)),
                        onPressed: () => Get.to(Onboarding()),
                      ),
                      SizedBox(height: 10),
                      isLoading
                          ? CircularProgressIndicator(color: KColors.primary)
                          : Button(
                              child: Text("Se connecter"),
                              onPressed: () => Get.to(LogePage()),
                              backgroundColor: KColors.primary,
                              borderColor: KColors.primary,
                              foregroundColor: Colors.white),
                      SizedBox(height: 10),
                      Button(
                          child: Text("S'inscrire"),
                          onPressed: () => Get.to(ProfilUser()),
                          backgroundColor: Colors.white,
                          borderColor: KColors.primary,
                          foregroundColor: KColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Validation de l'email correspondant au format exemple@gmail.com
  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  // Validation du mot de passe qui doit avoir minimum 8 caractères, une lettre majuscule et un chiffre
  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }
}
