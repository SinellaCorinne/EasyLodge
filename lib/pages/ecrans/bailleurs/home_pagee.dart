import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/bailleurs/ajout_loge.dart';
import 'package:loge_app/theme/style.dart';
import '../../../composants/StatCard.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bannière de bienvenue
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A2A6C), Color(0xFFb21f1f)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Bienvenue, Bailleur 👋",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Fais louer ton logement en quelques clics.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section : Logements récents
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Logements récents", style: KTypography.h6(context)),
              Icon(Icons.apartment, color: KColors.primary),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: logementsRecents.length,
              padding: const EdgeInsets.only(right: 8),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final logement = logementsRecents[index];
                return LogementCard(logement: logement);
              },
            ),
          ),

          const SizedBox(height: 32),

          // Résumé des annonces
          Row(
            children: const [
              Icon(Icons.campaign, color: Colors.black87),
              SizedBox(width: 8),
              Text("Résumé des annonces",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A2A6C), KColors.primary]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text("Toutes vos annonces sont à jour.",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistiques
          Row(
            children: const [
              Icon(Icons.bar_chart, color: Colors.black87),
              SizedBox(width: 8),
              Text("Statistiques",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              StatCard(label: "Réservations", count: 12),
              StatCard(label: "Messages", count: 5),
            ],
          ),

          const SizedBox(height: 30),

          // Bouton d'ajout
          Center(
            child: ElevatedButton.icon(
              onPressed: () => Get.to(AjoutLoge()),
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un logement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A2A6C),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
