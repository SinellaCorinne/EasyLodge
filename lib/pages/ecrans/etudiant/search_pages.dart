import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/details_loge.dart';
import '../../../composants/filtres.dart';
import '../../../composants/liste_tile.dart';
import '../../../theme/style.dart';

class SearchPages extends StatelessWidget {

  const SearchPages({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        elevation: 2,
        title: Text(
          'EasyLodge',
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
          const Filtres(),
          const SizedBox(height: 10),

          // ✅ Le ListView doit être dans un Expanded
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: KListTile(
                    path: "assets/images/logement.jpeg",
                    title: "Studio moderne",
                    subtitle: "10 000 FCFA",
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
