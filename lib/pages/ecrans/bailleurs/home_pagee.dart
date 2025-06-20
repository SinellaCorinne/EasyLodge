import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/bailleurs/ajout_loge.dart';
import 'package:loge_app/pages/ecrans/bailleurs/reservations_page.dart';
import 'package:loge_app/theme/style.dart';
import '../../../composants/StatCard.dart';
import '../../../composants/liste_tile.dart';
import '../../../composants/logement_card.dart';

class HomePagee extends StatelessWidget {
  HomePagee({super.key});

  final logementsRecents = [
    {
      "titre": "Studio moderne",
      "lieu": "Calavi",
      "prix": "15 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
    {
      "titre": "Chambre simple",
      "lieu": "Abomey",
      "prix": "10 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
    {
      "titre": "Appartement T2",
      "lieu": "Cotonou",
      "prix": "25 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0), // ✅ Padding global ici
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bannière de bienvenue
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: KColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20), // léger padding intérieur conservé
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Bienvenue, Bailleur 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Faites louer votre logement en quelques clics.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section : Logements récents
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Logements récents", style: KTypography.h6(context)),
                  const Icon(Icons.apartment, color: KColors.primary),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: logementsRecents.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final logement = logementsRecents[index];
                    return LogementCard(logement: logement);
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Résumé des annonces
              const Row(
                children: [
                  Icon(Icons.campaign, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    "Résumé des annonces",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: KColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16), // allégé ici
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Toutes vos annonces sont à jour.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Statistiques
              const Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    "Statistiques",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      StatCard(label: "Logements actifs", count: 2),
                      SizedBox(height: 15),
                      StatCard(label: "Messages", count: 5),
                    ],
                  ),
                  Column(
                    children: [
                      StatCard(label: "Réservations", count: 12),
                      SizedBox(height: 15),
                      StatCard(label: "Logements inactifs", count: 5),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Boutons
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.to(AjoutLoge()),
                      icon: const Icon(Icons.add),
                      label: const Text("Ajouter un logement"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Get.to(ReservationsPage()),
                      icon: const Icon(Icons.houseboat_outlined),
                      label: const Text("Voir les réservations"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
