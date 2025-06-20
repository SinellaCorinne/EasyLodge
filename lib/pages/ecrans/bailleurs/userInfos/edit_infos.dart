import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';

import '../../../../theme/style.dart';
import 'package:loge_app/pages/ecrans/bailleurs/userInfos/user_infos_page.dart';

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({super.key});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;
  bool isFetching = true;
  final GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = box.read("token");
      if (token == null) {
        Get.snackbar("Erreur", "Token introuvable",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await dio.Dio().get(
        'http://192.168.100.192:8000/api/profile',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;

      nomController.text = data['nom'] ?? '';
      prenomController.text = data['prenom'] ?? '';
      telephoneController.text = data['telephone'] ?? '';
      emailController.text = data['email'] ?? '';
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de charger les données utilisateur.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isFetching = false);
    }
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await dio.Dio().put(
        'http://192.168.100.192:8000/api/profile',
        data: {
          'nom': nomController.text.trim(),
          'prenom': prenomController.text.trim(),
          'email': emailController.text.trim(),
          'telephone': telephoneController.text.trim(),

        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Succès", "Informations mises à jour avec succès !",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.off(() => UserInfoPage());
      } else {
        _showError("Échec de la mise à jour des données.");
      }
    } catch (e) {
      _showError("Une erreur est survenue : ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    Get.snackbar("Erreur", message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title:  Text("Modifier mes infos", style: KTypography.h3(context,color:Colors.white)),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildTextField(Iconsax.user, "Nom", nomController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.user_tick, "Prénom", prenomController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.message, "Email", emailController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.call, "Téléphone", telephoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/images/college campus-rafiki.png"),
          radius: 40,
        ),
        const SizedBox(height: 12),
        Text("Mettez à jour vos informations", style: KTypography.h5(context)),
        const SizedBox(height: 8),
        Text(
          "Veuillez remplir tous les champs ci-dessous.",
          style: KTypography.h5(context, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField(
      IconData icon,
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) =>
      value == null || value.trim().isEmpty ? "Ce champ est requis" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: KColors.primary),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: KColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isLoading ? null : _updateUserInfo,
        icon: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white),
        )
            : const Icon(Iconsax.save_2, color: Colors.white),
        label: Text(
          isLoading ? "Enregistrement..." : "Enregistrer",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
