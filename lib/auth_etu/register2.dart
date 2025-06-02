import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loge_app/composants/textField.dart';
import 'package:loge_app/pages/ecrans/bailleurs/composants/baill_page.dart';
import 'login.dart';
import '../composants/Button.dart';
import '../theme/style.dart';
// ... imports identiques

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final _formKey = GlobalKey<FormState>();
  final dio_package.Dio dio = dio_package.Dio();
  final ImagePicker picker = ImagePicker();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  File? justificatifFile;
  bool isLoading = false;
  final box = GetStorage();

  // Fixe le rôle à "bailleur"
  final String role = "bailleur";

  Future<void> pickJustificatif() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => justificatifFile = File(pickedFile.path));
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (justificatifFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez téléverser un justificatif")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final formData = dio_package.FormData.fromMap({
        "nom": nomController.text.trim(),
        "prenom": prenomController.text.trim(),
        "tel": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "role_user": role,
        "password_confirmation": rePasswordController.text.trim(),
        "justificatif": await dio_package.MultipartFile.fromFile(
          justificatifFile!.path,
          filename: justificatifFile!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '', // <-- Remplis ton endpoint ici
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final data = response.data;
      final String message = data['message'] ?? "Inscription réussie";

      // Message de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      // Redirection après succès
      Get.off(() =>  BaillPage());

    } on dio_package.DioException catch (e) {
      final error = e.response?.data['message'] ?? "Erreur lors de l'inscription";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur inattendue s'est produite.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset("assets/images/Tiny house-bro.png", width: 70, height: 70),
                    const SizedBox(height: 15),
                    Text("Bienvenue cher bailleur", style: KTypography.h3(context, color: KColors.primary)),
                    const SizedBox(height: 20),

                    Textfield(
                      name: "Noms",
                      controller: nomController,
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre nom' : null,
                    ),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Prénoms",
                      controller: prenomController,
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre prénom' : null,
                    ),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Email",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
                        if (!GetUtils.isEmail(value)) return 'Email invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Numéro de téléphone",
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Veuillez entrer votre téléphone';
                        if (!RegExp(r'^\d{8,15}$').hasMatch(value)) return 'Numéro invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Mot de passe",
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Veuillez entrer un mot de passe';
                        if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Confirmer le mot de passe",
                      controller: rePasswordController,
                      validator: (value) {
                        if (value != passwordController.text) return 'Les mots de passe ne correspondent pas';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Justificatif", style: KTypography.h6(context)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: pickJustificatif,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: justificatifFile == null ? Colors.red : KColors.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.upload_file, color: KColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                justificatifFile != null
                                    ? justificatifFile!.path.split('/').last
                                    : "Téléverser votre justificatif",
                                style: TextStyle(color: KColors.primary),
                                overflow: TextOverflow.ellipsis,
                              ),
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
                      onPressed: () => Get.to(() => BaillPage()),  //_register,
                      backgroundColor: const Color(0xFF0B0A5C),
                      borderColor: const Color(0xFF0B0A5C),
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Vous avez déjà un compte ? "),
                        GestureDetector(
                          onTap: () => Get.to(() => Login()),
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
            ),
          ),
        ],
      ),
    );
  }
}
