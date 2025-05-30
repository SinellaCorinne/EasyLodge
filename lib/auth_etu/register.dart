import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/composants/textField.dart';
import 'package:loge_app/pages/ecrans/etudiant/composants/loge_page.dart';
import '../composants/Button.dart';
import '../theme/style.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final dio_package.Dio dio = dio_package.Dio();

  bool isLoading = false;
  String? _errorMessage;
  String? _token;
  File? studentCardFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickStudentCard() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        studentCardFile = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                Image.asset("assets/images/Tiny house-bro.png", width: 70, height: 70),
                const SizedBox(height: 15),
                Text("Bienvenue cher étudiant", style: KTypography.h3(context, color: KColors.primary)),
                const SizedBox(height: 20),
                Textfield(name: "Noms", controller: firstNameController),
                const SizedBox(height: 10),
                Textfield(name: "Prénoms", controller: lastNameController),
                const SizedBox(height: 10),
                Textfield(name: "Email", controller: emailController),
                const SizedBox(height: 10),
                Textfield(name: "Numéro de téléphone", controller: phoneController),
                const SizedBox(height: 10),
                Textfield(name: "Mot de passe", controller: passwordController),
                const SizedBox(height: 10),
                Textfield(name: "Confirmer le mot de passe", controller: rePasswordController),
                const SizedBox(height: 15),

                // Upload de justificatif
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Carte Étudiant", style: KTypography.h6(context)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickStudentCard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                          studentCardFile != null
                              ? studentCardFile!.path.split('/').last
                              : "Téléverser votre carte étudiant",
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
                  onPressed:  () => Get.to(LogePage()),
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
                        Get.to(() => Login()); // <-- Remplace LoginPage() par ta vraie page de connexion
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

              ],
            ),
          ),
        )
      ]),
    );
  }
}
