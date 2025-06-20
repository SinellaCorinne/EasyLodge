import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/composants/Button.dart';
import 'package:loge_app/pages/ecrans/bailleurs/composants/baill_page.dart';

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

  final dio = dio_package.Dio();
  String? _imageBase64;

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

  Future<void> _submitForm() async {
    final formData = {
      "titre": titreController.text,
      "description": descriptionController.text,
      "type": typeController.text,
      "prix": int.tryParse(prixController.text) ?? 0,
      "localisation": localisationController.text,
      "photo": _imageBase64 ?? "",
    };

    await GetStorage.init();
    final box = GetStorage();
    final token = box.read('auth_token');

    if (token == null) {
      throw Exception("Token introuvable");
    }

    try {
      final response = await dio.post(
        "http://192.168.100.192:8000/api/logements",
        data: formData,
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.to(() => BaillPage());
      } else {
        print("Erreur : ${response.statusCode}");
        print("Message : ${response.data}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
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
              Text(
                'Titre',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: titreController,
                decoration: InputDecoration(
                  hintText: 'Entrez le titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Entrez la description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: typeController,
                decoration: InputDecoration(
                  hintText: 'Entrez le type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Prix (FCFA)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prixController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Entrez le prix',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Localisation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:KColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: localisationController,
                decoration: InputDecoration(
                  hintText: 'Entrez la localisation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponible ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: KColors.primary,
                    ),
                  ),
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
                    backgroundColor: const Color(0xFF1A2A6C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
                ),//KColors.primary
              const SizedBox(height: 24),
              Center(
                child: Button(child: Text("Ajouter un logement"),onPressed: _submitForm,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
