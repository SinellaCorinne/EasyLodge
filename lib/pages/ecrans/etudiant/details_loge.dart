// detail_loge.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/reservation.dart';
import '../../../theme/style.dart';

class DetailLoge extends StatefulWidget {
  const DetailLoge({super.key});

  @override
  State<DetailLoge> createState() => _DetailLogeState();
}

class _DetailLogeState extends State<DetailLoge> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
  ];

  final String logementId = "1"; // Exemple d'ID
  final String titre = "Studio moderne à Calavi";
  final String prix = "15 000 FCFA / mois";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: KColors.primary,
        backgroundColor: Colors.white,
        title: Text(
          "Détails du logement",
          style: KTypography.h3(context, color: KColors.primary),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Galerie
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) => Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _images.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.blueGrey
                                : Colors.blueGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Informations principales
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: KTypography.h4(context, color: KColors.primary)),
                  const SizedBox(height: 12),
                  Text("Prix : $prix", style: KTypography.h6(context)),
                  const SizedBox(height: 12),
                  Text("Surface : 25 m²\nÉquipements : Wifi, Cuisine, Climatisation",
                      style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  const SizedBox(height: 12),
                  Text("Règles : Non-fumeur, Pas d’animaux",
                      style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: const Text("Contacter", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: KColors.primary, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Get.to(() => ReservationPage(
                            logementId: logementId,
                            titre: titre,
                            prix: prix,
                          )),
                          child: Text("Réserver",
                              style: TextStyle(fontWeight: FontWeight.bold, color: KColors.primary)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          Text("Avis des anciens locataires", style: KTypography.h5(context, color: KColors.primary)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              leading: CircleAvatar(
                backgroundColor: KColors.primary.withOpacity(0.15),
                child: const Icon(Icons.person, color: KColors.primary),
              ),
              title: const Text("Très bon logement, propre et calme."),
              subtitle: Row(
                children: List.generate(5, (_) => const Icon(Icons.star, size: 16, color: Colors.orange)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
