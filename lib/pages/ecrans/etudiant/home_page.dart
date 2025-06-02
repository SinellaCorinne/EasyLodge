import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/recherche_avance.dart';
import '../../../composants/logement_card.dart';
import '../../../theme/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logementsRecents = [
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Studio moderne", "lieu": "Calavi", "prix": "15 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Chambre simple", "lieu": "Abomey", "prix": "10 000 FCFA", "image": "assets/images/logement.jpeg"},
      {"titre": "Appartement T2", "lieu": "Cotonou", "prix": "25 000 FCFA", "image": "assets/images/logement.jpeg"},

    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière dynamique
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A2A6C), Color(0xFFb21f1f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👋 Bienvenue, Étudiant",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Trouve ton logement étudiant en quelques clics.",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section : Logements récents
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("🏠 Logements récents", style: KTypography.h5(context)),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 240,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

            // Recherche avancée
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Get.to(RecherchePage()),
                icon: const Icon(Icons.search),
                label: const Text("Recherche avancée"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Astuces
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("💡 Conseils logement", style: KTypography.h6(context)),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Icon(Icons.tips_and_updates, color: Colors.amber.shade700),
                  title: Text("🔍 Vérifie bien l'état du logement avant de réserver."),
                  subtitle: Text("Un état des lieux est fortement recommandé."),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
