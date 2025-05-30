import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/details_loge.dart';
import '../../../theme/style.dart';

class SearchPages extends StatelessWidget {
  const SearchPages({super.key});

  @override
  Widget build(BuildContext context) {
    final resultats = [
      {
        "titre": "Chambre proche campus",
        "lieu": "Calavi",
        "prix": "12 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Studio tout confort",
        "lieu": "Cotonou",
        "prix": "20 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Appartement étudiant",
        "lieu": "Abomey",
        "prix": "18 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Chambre proche campus",
        "lieu": "Calavi",
        "prix": "12 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Studio tout confort",
        "lieu": "Cotonou",
        "prix": "20 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Appartement étudiant",
        "lieu": "Abomey",
        "prix": "18 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Chambre proche campus",
        "lieu": "Calavi",
        "prix": "12 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Studio tout confort",
        "lieu": "Cotonou",
        "prix": "20 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Appartement étudiant",
        "lieu": "Abomey",
        "prix": "18 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Chambre proche campus",
        "lieu": "Calavi",
        "prix": "12 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Studio tout confort",
        "lieu": "Cotonou",
        "prix": "20 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
      {
        "titre": "Appartement étudiant",
        "lieu": "Abomey",
        "prix": "18 000 FCFA",
        "image": "assets/images/logement.jpeg"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:  AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        elevation: 2,
        title: Text(
          'Résultats',
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bannière
          const SizedBox(height: 10),

          // Résultats ou message vide
          Expanded(
            child: resultats.isEmpty
                ? Center(
                    child: Text(
                      'Aucun logement trouvé pour votre recherche.',
                      style: KTypography.h5(context, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: resultats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final logement = resultats[index];
                      return GestureDetector(
                        onTap: () => Get.to(DetailLoge()),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16)),
                                child: Image.asset(
                                  logement["image"]!,
                                  width: 120,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(logement["titre"]!,
                                          style: KTypography.h5(context)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: KColors.tertiary, size: 16),
                                          const SizedBox(width: 4),
                                          Text(logement["lieu"]!,
                                              style: TextStyle(
                                                  color: Colors.grey[700])),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(logement["prix"]!,
                                          style: TextStyle(
                                              color: KColors.primary,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
