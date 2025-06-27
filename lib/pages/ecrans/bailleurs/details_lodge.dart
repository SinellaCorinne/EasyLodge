import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/reservation.dart';
import '../../../theme/style.dart';
import 'logement.dart';

class DetailLodge extends StatefulWidget {
  final Logement logement;

  const DetailLodge({super.key, required this.logement});

  @override
  State<DetailLodge> createState() => _DetailLodgeState();
}

class _DetailLodgeState extends State<DetailLodge> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final logement = widget.logement;

    // Debug dans le terminal
    print("LOGEMENT >> ID: ${logement.id}, Titre: ${logement.titre}, Prix: ${logement.prix}");

    final images = logement.images ?? [];

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
          // Galerie d'images
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
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
                    itemCount: images.isNotEmpty ? images.length : 1,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      if (images.isNotEmpty) {
                        final imageUrl = images[index];
                        return imageUrl.startsWith("http")
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, error, __) {
                                  print("Erreur de chargement image : $error");
                                  return Image.asset(
                                    "assets/images/logement.jpeg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                },
                              )
                            : Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity);
                      } else {
                        return Image.asset(
                          "assets/images/logement.jpeg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
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
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Informations du logement
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(logement.titre ?? "Titre non disponible",
                      style: KTypography.h4(context, color: KColors.primary)),
                  const SizedBox(height: 12),
                  Text("Prix : ${logement.prix?.toString() ?? "N/A"} FCFA",
                      style: KTypography.h6(context)),
                  const SizedBox(height: 12),
                  Text(
                    "Description : ${logement.description ?? "Aucune description disponible"}",
                    style: TextStyle(color: Colors.grey[700], height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 3,
                          ),
                          onPressed: () {
                            print("Bouton contacter pressé");
                            // TODO: Action contact
                          },
                          child: const Text(
                            "Contacter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: KColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            try {
                              print("Navigation vers page réservation...");
                              Get.to(() => ReservationPage(
                                logementId: logement.id?.toString()?? "1",
                                titre: logement.titre ?? "Titre non disponible",
                                prix: logement.prix?.toString() ?? "0",
                              ));
                            } catch (e, stack) {
                              print("Erreur lors de la navigation : $e");
                              print(stack);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur : $e")),
                              );
                            }
                          },
                          child: Text(
                            "Réserver",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: KColors.primary,
                            ),
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

          // Avis client
          Text("Avis des anciens locataires",
              style: KTypography.h5(context, color: KColors.primary)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            color: Colors.white,
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, color: KColors.primary),
              ),
              title: Text("Très bon logement, propre et calme."),
              subtitle: Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.orange),
                  Icon(Icons.star, size: 16, color: Colors.orange),
                  Icon(Icons.star, size: 16, color: Colors.orange),
                  Icon(Icons.star, size: 16, color: Colors.orange),
                  Icon(Icons.star, size: 16, color: Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
