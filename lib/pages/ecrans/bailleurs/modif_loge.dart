import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/pages/ecrans/bailleurs/mes_loges_pages.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class LogementEditPage extends StatefulWidget {
  final Map<String, dynamic> logementData;

  const LogementEditPage({
    super.key,
    required this.logementData,
  });

  @override
  _LogementEditPageState createState() => _LogementEditPageState();
}

class _LogementEditPageState extends State<LogementEditPage> {
  final dio = dio_package.Dio();

  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  late TextEditingController prixController;
  late TextEditingController localisationController;

  bool disponibilite = true;
  PlatformFile? _selectedImage;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    titreController = TextEditingController(text: widget.logementData['titre'] ?? '');
    descriptionController = TextEditingController(text: widget.logementData['description'] ?? '');
    typeController = TextEditingController(text: widget.logementData['type'] ?? '');
    prixController = TextEditingController(text: widget.logementData['prix']?.toString() ?? '0');
    localisationController = TextEditingController(text: widget.logementData['localisation'] ?? '');
    disponibilite = widget.logementData['disponibilite'] ?? true;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final bytes = File(file.path!).readAsBytesSync();
      setState(() {
        _selectedImage = file;
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _submitUpdate() async {
    print("Soumission...");
    final logementId = widget.logementData['logement_id'];

    final formData = {
      "titre": titreController.text,
      "description": descriptionController.text,
      "type": typeController.text,
      "prix": int.tryParse(prixController.text) ?? 0,
      "localisation": localisationController.text,
      "disponibilite": disponibilite,
    };

    if (_imageBase64 != null) {
      formData["photo"] = _imageBase64!;
    }

    await GetStorage.init();
    final box = GetStorage();
    final token = box.read('auth_token');

    if (token == null) {
      Get.snackbar("Erreur", "Token non trouvé", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
       print("Envoi ");
      final response = await dio.put(
        "${ApiBaseUrl.baseUrl}/logements/$logementId",
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.off(() => const MesLogesPages());
      } else {
        print("Erreur API : ${response.statusCode} => ${response.data}");
        Get.snackbar("Erreur", "Erreur lors de la mise à jour",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      print("Exception lors de l'envoi : $e");
      Get.snackbar("Exception", "$e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier un logement"),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
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
                child: ElevatedButton(
                  onPressed: _submitUpdate,
                  child: const Text("Mettre à jour le logement"),
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
