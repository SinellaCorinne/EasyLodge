import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/reservation.dart';
import '../../../theme/style.dart';

class DetailLoge extends StatefulWidget {
  DetailLoge({super.key});

  @override
  State<DetailLoge> createState() => _DetailLogeState();
}

class _DetailLogeState extends State<DetailLoge> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "assets/images/logement.jpeg",
    "assets/images/logement2.jpeg",
    "assets/images/logement3.jpeg","assets/images/logement.jpeg",
    "assets/images/logement2.jpeg",
    "assets/images/logement3.jpeg","assets/images/logement.jpeg",
    "assets/images/logement2.jpeg",
    "assets/images/logement3.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text(
          "Détails du logement",
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          // Galerie avec indicateur
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
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
                                ? KColors.primary
                                : KColors.primary.withOpacity(0.3),
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

          // Infos principales dans une Card
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Studio moderne à Calavi",
                      style:
                      KTypography.h4(context, color: KColors.primary)),
                  const SizedBox(height: 12),
                  Text("Prix : 15 000 FCFA / mois",
                      style: KTypography.h6(context)),
                  const SizedBox(height: 12),
                  Text(
                    "Surface : 25 m²\nÉquipements : Wifi, Cuisine, Climatisation",
                    style: TextStyle(color: Colors.grey[700], height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Text("Règles : Non-fumeur, Pas d’animaux",
                      style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  const SizedBox(height: 24),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 3,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Contacter",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: KColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Get.to(ReservationPage()),
                          child: Text(
                            "Réserver",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: KColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Avis
          Text("Avis des anciens locataires",
              style: KTypography.h5(context, color: KColors.primary)),
          const SizedBox(height: 12),

          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: Colors.white,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              leading: CircleAvatar(
                backgroundColor: KColors.primary.withOpacity(0.15),
                child: const Icon(Icons.person, color: KColors.primary),
              ),
              title: const Text("Très bon logement, propre et calme."),
              subtitle: Row(
                children: List.generate(
                  5,
                      (_) => const Icon(Icons.star, size: 16, color: Colors.orange),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
