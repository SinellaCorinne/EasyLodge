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
import 'package:get_storage/get_storage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final dio_package.Dio dio = dio_package.Dio();
  final ImagePicker _picker = ImagePicker();

  final box = GetStorage();

  String? role;

  bool isLoading = false;
  File? studentCardFile;

  @override
  void initState() {
    super.initState();
    role = box.read('selectedRole');
  }

  Future<void> pickStudentCard() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        studentCardFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (studentCardFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez téléverser votre carte étudiant")),
      );
      return;
    }

    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rôle non sélectionné")),
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
        "password_confirmation": rePasswordController.text.trim(),
        "role_user": role,
        "carte_etudiant": await dio_package.MultipartFile.fromFile(
          studentCardFile!.path,
          filename: studentCardFile!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '',
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("Réponse API: ${response.data}");
      Get.to(() => LogePage());
    } on dio_package.DioException catch (e) {
      final error = e.response?.data['message'] ?? "Erreur lors de l'inscription";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } catch (e) {
      print("Erreur inattendue: $e");
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
                    Text("Bienvenue cher étudiant", style: KTypography.h3(context, color: KColors.primary)),
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
                            Expanded(
                              child: Text(
                                studentCardFile != null
                                    ? studentCardFile!.path.split('/').last
                                    : "Téléverser votre carte étudiant",
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
                      onPressed: isLoading ? null : () => Get.to(() => LogePage()), // _register,
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
                          onTap: () => Get.to(() =>  Login()),
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
