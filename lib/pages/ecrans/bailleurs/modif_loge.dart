import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/pages/ecrans/bailleurs/mes_loges_pages.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier un logement")),
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
                  color: KColors.primary,
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
                    backgroundColor: KColors.primary,
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
                ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Mettre à jour le logement"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
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
            ],
          ),
        ),
      ),
    );
  }
}
