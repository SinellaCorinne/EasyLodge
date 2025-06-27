import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/details_loge.dart';
import '../../../composants/liste_tile.dart';
import '../../../theme/style.dart';

class SearchPages extends StatelessWidget {
  final List<dynamic> resultats;

  const SearchPages({super.key, required this.resultats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        elevation: 2,
        title: Text(
          'Résultats de recherche',
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Logements disponibles',
              style: KTypography.h3(context, color: KColors.primary),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: resultats.isEmpty
                ? Center(
                    child: Text(
                      "Aucun logement trouvé.",
                      style: KTypography.h4(context, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: resultats.length,
                    itemBuilder: (context, index) {
                      final logement = resultats[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => DetailLoge(logementData: logement));
                          },
                          child: KListTile(
                  logementData: logement,
                  path: logement["image"] ?? "assets/images/logement.jpeg",
                  title: logement["titre"] ?? "",
                  subtitle: logement["prix"] ?? "",
                ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
