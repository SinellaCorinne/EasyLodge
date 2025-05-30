import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/composants/textField.dart';
import 'package:loge_app/pages/ecrans/bailleurs/composants/baill_page.dart';
import '../auth_etu/login.dart';
import '../composants/Button.dart';
import '../composants/logo.dart';
import '../pages/ecrans/etudiant/composants/loge_page.dart';
import '../theme/style.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final dio_package.Dio dio = dio_package.Dio();
  final ImagePicker picker = ImagePicker();

  File? justificatifFile;
  bool isLoading = false;
  String? _errorMessage;
  String? _token;

  Future<void> pickJustificatif() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        justificatifFile = File(pickedFile.path);
      });
    }
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Veuillez entrer un email.";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(email)) {
      return "Email invalide.";
    }
    return null;
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
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Tiny house-bro.png",
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 15),
                  Text("Bienvenue cher Bailleur",
                      style: KTypography.h3(context, color: KColors.primary)),
                  const SizedBox(height: 20),
                  Textfield(name: "Noms", controller: firstNameController),
                  const SizedBox(height: 10),
                  Textfield(name: "Prénoms", controller: lastNameController),
                  const SizedBox(height: 10),
                  Textfield(name: "Email", controller: emailController),
                  const SizedBox(height: 10),
                  Textfield(
                      name: "Numéro de téléphone", controller: phoneController),
                  const SizedBox(height: 10),
                  Textfield(
                    name: "Définissez un mot de passe",
                    controller: passwordController,
                  ),
                  const SizedBox(height: 10),
                  Textfield(
                    name: "Confirmer le mot de passe",
                    controller: rePasswordController,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Documents justificatifs (Cip ou autres)",
                        style: KTypography.h6(context)),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: pickJustificatif,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: KColors.primary),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.upload_file, color: KColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            justificatifFile != null
                                ? justificatifFile!.path.split('/').last
                                : "Téleverser un document",
                            style: TextStyle(color: KColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Button(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("S'inscrire"),
                    onPressed: () => Get.to(BaillPage()),
                    backgroundColor: const Color(0xFF0B0A5C),
                    borderColor: const Color(0xFF0B0A5C),
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous avez déjà un compte ? "),
                      GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              Login()); // <-- Remplace LoginPage() par ta vraie page de connexion
                        },
                        child: Text(
                          "Connectez-vous",
                          style: TextStyle(
                            color: KColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],),
          ),
        )
      ]),
    );
  }
}
