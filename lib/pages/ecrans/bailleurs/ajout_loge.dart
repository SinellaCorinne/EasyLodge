import 'package:flutter/material.dart';
import 'package:loge_app/composants/textField.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';

class AjoutLoge extends StatelessWidget {
  const AjoutLoge({super.key});

  @override
  Widget build(BuildContext context) {
    final titreController = TextEditingController();
    final descriptionController = TextEditingController();
    final prixController = TextEditingController();
    final equipementsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColors.primary,
        title: Text(
          "Ajouter un logement",
          style: KTypography.h3(context, color: Colors.white),
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Informations générales",
                    style: KTypography.h4(context)),
                const SizedBox(height: 16),
                Textfield(name: "Titre"),
                const SizedBox(height: 12),
                Textfield(name: "Description"),
                const SizedBox(height: 12),
                Textfield(name: "Prix"),
                const SizedBox(height: 12),
                Textfield(name: "Équipements"),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 12),
                Text("Photos",
                    style: KTypography.h4(context)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Logique d'upload des photos
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: KColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text("Uploader des photos"),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        // Logique d'enregistrement
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
    );
  }
}
