import 'dart:io';
import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loge_app/composants/Button.dart';
import '../../../theme/style.dart';

class AjoutLoge extends StatefulWidget {
  const AjoutLoge({super.key});

  @override
  State<AjoutLoge> createState() => _AjoutLogeState();
}

class _AjoutLogeState extends State<AjoutLoge> {
  final _formKey = GlobalKey<FormState>();
  final dio_package.Dio dio = dio_package.Dio();

  final titreController = TextEditingController();
  final typeController = TextEditingController();
  final prixController = TextEditingController();
  final descriptionController = TextEditingController();
  final localisationController =TextEditingController();

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> selected = await _picker.pickMultiImage();
    if (selected.isNotEmpty) {
      setState(() {
        _images.clear();
        _images.addAll(selected);
      });
    }
  }

  Future<void> envoyerLogement() async {
    try {
      final formData = dio_package.FormData.fromMap({
        "titre": titreController.text.trim(),
        "type_logement": typeController.text.trim(),
        "prix": prixController.text.trim(),
        "description": descriptionController.text.trim(),
        'localisation':localisationController.text.trim(),
        "photos": [
          for (var image in _images)
            await dio_package.MultipartFile.fromFile(image.path, filename: image.name)
        ],
      });

      final response = await dio.post(
        "https://votre-api.com/ajout-logement", // Remplace ici
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Succès", "Logement ajouté avec succès",
            backgroundColor: Colors.green, colorText: Colors.white);
        _formKey.currentState?.reset();
        titreController.clear();
        typeController.clear();
        prixController.clear();
        descriptionController.clear();
        localisationController.clear();
        setState(() => _images.clear());
      } else {
        Get.snackbar("Erreur", "Échec de l'ajout du logement",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur : $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    titreController.dispose();
    typeController.dispose();
    prixController.dispose();
    descriptionController.dispose();
    localisationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColors.primary,
        title: Text("Ajouter un logement", style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Informations générales", style: KTypography.h4(context)),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: titreController,
                    decoration: InputDecoration(
                      labelText: "Titre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? "Veuillez entrer un titre" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: "Type de logement",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Veuillez entrer le type de logement"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: prixController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Prix",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Veuillez entrer le prix";
                      if (int.tryParse(value) == null) return "Prix invalide";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? "Entrez les équipements" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: localisationController,
                    decoration: InputDecoration(
                      labelText: "Lieu",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? "Entrez le lieu" : null,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  Text("Photos", style: KTypography.h4(context)),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: pickImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: KColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text("Uploader des photos"),
                  ),
                  const SizedBox(height: 8),

                  if (_images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _images.map((img) {
                        return Chip(label: Text(img.name));
                      }).toList(),
                    ),

                  const SizedBox(height: 30),

                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_images.isEmpty) {
                              Get.snackbar("Erreur", "Veuillez sélectionner au moins une photo",
                                  backgroundColor: Colors.orange, colorText: Colors.white);
                            } else {
                              envoyerLogement();
                            }
                          }
                        },
                        child: const Text("Enregistrer"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
