import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/composants/textField.dart';
import 'package:loge_app/pages/ecrans/etudiant/composants/loge_page.dart';
import '../composants/Button.dart';
import '../composants/api_url.dart';
import '../composants/profil_user.dart';
import '../pages/ecrans/etudiant/userInfos/termes.dart';
import '../theme/style.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late dio_package.Dio dio;
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController universiteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  File? studentCardFile;
  bool isLoading = false;
  String? role;
  bool accepteConditions = false;

  @override
  void initState() {
    super.initState();
    dio = dio_package.Dio(
      dio_package.BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    role = box.read('selectedRole');
    if (role == null) {
      Get.off(() => ProfilUser());
    }
    print("Rôle sélectionné: $role");
  }

  Future<void> pickStudentCard() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => studentCardFile = File(pickedFile.path));
    }
  }

  Future<void> _register() async {
    print("Soumission...");
    if (!_formKey.currentState!.validate()) return;

    if (!accepteConditions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous devez accepter les termes et conditions.")),
      );
      return;
    }

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
        'universite': universiteController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "password_confirmation": rePasswordController.text.trim(),
        "role_user": role,
        "carte_etudiant": await dio_package.MultipartFile.fromFile(
          studentCardFile!.path,
          filename: studentCardFile!.path.split('/').last,
        ),
      });

      print("Envoi à : ${ApiBaseUrl.baseUrl}/register");

      final response = await dio.post(
        '${ApiBaseUrl.baseUrl}/register',
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data;
        final token = data['token'];
        if (token != null) {
          await box.write('auth_token', token);
          print("Token reçu, navigation vers LogePage");
          Get.offAll(() => LogePage());
        } else {
          print("Token non trouvé dans la réponse");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Token non reçu, impossible de continuer.")),
          );
        }
      } else {
        print("Réponse inattendue");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'inscription.")),
        );
      }
    }
    on dio_package.DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("HEADERS: ${e.response?.headers}");

      // Extraction améliorée du message d'erreur
      String errorMessage = "Erreur lors de l'inscription";

      if (e.response?.data != null && e.response?.data is Map) {
        final responseData = e.response!.data as Map;

        if (responseData.containsKey('errors') && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = errors.values.first[0] ?? errorMessage;
          }
        } else if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        isLoading = false;
      });
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
                    Text("Bienvenue cher etudiant ", style: KTypography.h3(context, color: KColors.primary)),
                    const SizedBox(height: 20),
                    Textfield(name: "Noms", controller: nomController, validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre nom' : null),
                    const SizedBox(height: 10),
                    Textfield(name: "Prénoms", controller: prenomController, validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre prénom' : null),
                    const SizedBox(height: 10),
                    Textfield(name: "Université", controller: universiteController, validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre université' : null),
                    const SizedBox(height: 10),
                    Textfield(name: "Email", controller: emailController, validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
                      if (!GetUtils.isEmail(value)) return 'Email invalide';
                      return null;
                    }),
                    const SizedBox(height: 10),
                    Textfield(
                      name: "Numéro de téléphone",
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre téléphone';
                        }
                        if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
                          return 'Numéro invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Textfield(name: "Mot de passe", controller: passwordController, validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez entrer un mot de passe';
                      if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                      return null;
                    }),
                    const SizedBox(height: 10),
                    Textfield(name: "Confirmer le mot de passe", controller: rePasswordController, validator: (value) {
                      if (value != passwordController.text) return 'Les mots de passe ne correspondent pas';
                      return null;
                    }),
                    const SizedBox(height: 15),
                    Align(alignment: Alignment.centerLeft, child: Text("Document justificatif", style: KTypography.h6(context))),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: pickStudentCard,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: studentCardFile == null ? Colors.red : KColors.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.upload_file, color: KColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                studentCardFile != null
                                    ? studentCardFile!.path.split('/').last
                                    : "Téléverser un justificatif",
                                style: TextStyle(color: KColors.primary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CheckboxListTile(
                      value: accepteConditions,
                      onChanged: (value) => setState(() => accepteConditions = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: RichText(
                        text: TextSpan(
                          text: "En cochant, vous acceptez les ",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "termes et conditions d'utilisation",
                              style: TextStyle(
                                color: KColors.secondary,
                                decoration: TextDecoration.underline,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => TermesConditionsPage()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Button(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("S'inscrire"),
                      onPressed: _register,
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
                          onTap: () => Get.to(() => const Login()),
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
