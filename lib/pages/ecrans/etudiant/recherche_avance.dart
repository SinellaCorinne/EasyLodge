import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/composants/textField.dart';
import 'package:loge_app/pages/ecrans/etudiant/search_pages.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';

class RecherchePage extends StatelessWidget {
  const RecherchePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white, // couleur douce de fond
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        elevation: 2,
        title: Text(
          'Recherche avancée',
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Localisation
            Text(
              'Localisation',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            const SizedBox(height: 8),
            Textfield(
              name: 'Localisation',

            ),
            const SizedBox(height: 20),

            // Type de logement
            Text(
              'Type de logement',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: 'Studio',
              items: ["Studio", "Chambre", "Colocation"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Intervalle de prix
            Text(
              'Intervalle de prix (FCFA)',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prix min',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prix max',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nombre de chambres
            Text(
              'Nombre de chambres',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            const SizedBox(height: 8),
            Textfield(
              name: 'Nombre de chambre',

              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 36),

            // Bouton Rechercher
            Center(
              child: Button(
                onPressed: () => Get.to(SearchPages()),

                child: const Text(
                  "Rechercher",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
