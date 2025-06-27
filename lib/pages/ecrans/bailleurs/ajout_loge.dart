import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/composants/Button.dart';
import 'package:loge_app/pages/ecrans/bailleurs/composants/baill_page.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class AjoutLoge extends StatefulWidget {
  @override
  _AjoutLogeState createState() => _AjoutLogeState();
}

class _AjoutLogeState extends State<AjoutLoge> {
  final titreController = TextEditingController();
  final descriptionController = TextEditingController();
  final typeController = TextEditingController();
  final prixController = TextEditingController();
  final localisationController = TextEditingController();
  bool disponibilite = true;
  PlatformFile? _selectedImage;
  String? _imagePath; // Utilisez un chemin d'image au lieu de base64
  final dio = dio_package.Dio();
  final String defaultImagePath = 'assets/images/logement.jpg';

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _selectedImage = file;
        _imagePath = file.path; // Stockez le chemin de l'image
      });
    }
  }

  Future<void> _submitForm() async {
    await GetStorage.init();
    final box = GetStorage();
    final token = box.read('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token manquant. Veuillez vous reconnecter.")),
      );
      return;
    }

    // Utilisez le chemin de l'image par défaut si aucune image n'est sélectionnée
    if (_imagePath == null) {
      _imagePath = defaultImagePath;
    }

    final formData = {
      "titre": titreController.text,
      "description": descriptionController.text,
      "type": typeController.text,
      "prix": int.tryParse(prixController.text) ?? 0,
      "localisation": localisationController.text,
      "disponibilite": disponibilite,
      "photo": _imagePath, // Envoyez le chemin de l'image
    };

    try {
      final response = await dio.post(
        "${ApiBaseUrl.baseUrl}/logements",
        data: jsonEncode(formData),
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Succès", "Logement ajouté avec succès.",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAll(() => BaillPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur inconnue.")),
        );
      }
    } on dio_package.DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      String errorMessage = "Erreur lors de l'ajout.";
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = errors.values.first[0] ?? errorMessage;
          }
        } else if (data.containsKey('message')) {
          errorMessage = data['message'];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      print("Autre erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur inattendue")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un logement"),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Titre"),
              _buildTextField(titreController, "Entrez le titre"),
              _buildLabel("Description"),
              _buildTextField(descriptionController, "Entrez la description", maxLines: 3),
              _buildLabel("Type"),
              _buildTextField(typeController, "Entrez le type"),
              _buildLabel("Prix (FCFA)"),
              _buildTextField(prixController, "Entrez le prix", keyboardType: TextInputType.number),
              _buildLabel("Localisation"),
              _buildTextField(localisationController, "Entrez la localisation"),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Disponible ?", style: TextStyle(fontSize: 16, color: KColors.primary)),
                  Switch(
                    value: disponibilite,
                    onChanged: (value) {
                      setState(() {
                        disponibilite = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Choisir une photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Image sélectionnée : ${_selectedImage!.name}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 24),
              Center(
                child: Button(
                  child: const Text("Ajouter un logement"),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: KColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
