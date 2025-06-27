import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:loge_app/pages/ecrans/etudiant/reservation.dart';
import '../../../theme/style.dart';

class DetailLoge extends StatefulWidget {
  final Map<String, dynamic> logementData;

  const DetailLoge({super.key, required this.logementData});

  @override
  State<DetailLoge> createState() => _DetailLogeState();
}

class _DetailLogeState extends State<DetailLoge> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late String logementId;
  late String titre;
  late String prix;
  late String? photoBase64;

  final dio = Dio();
  final storage = GetStorage();

  List<dynamic> avis = [];
  bool isLoadingAvis = true;

  @override
  void initState() {
    super.initState();

    logementId = widget.logementData['logement_id'].toString();
    print("logementId : $logementId"); 
    titre = widget.logementData['titre'] ?? "Titre inconnu";
    prix = "${widget.logementData['prix'] ?? 0} FCFA / mois";
    photoBase64 = widget.logementData['photo'];
    print("DEBUG logementData reçu : ${widget.logementData}");

    fetchAvis();
  }

  Future<void> fetchAvis() async {
    final token = storage.read<String>('token');
    if (token == null) {
      Get.snackbar("Erreur", "Utilisateur non authentifié.",
          backgroundColor: Colors.red, colorText: Colors.white);
      setState(() => isLoadingAvis = false);
      return;
    }

    try {
      final response = await dio.get(
        "http://192.168.100.192:8000/api/avis/logement/$logementId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          avis = response.data['avis'];
          isLoadingAvis = false;
        });
      } else {
        Get.snackbar("Erreur", "Impossible de récupérer les avis.",
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() => isLoadingAvis = false);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur est survenue lors de la récupération des avis.",
          backgroundColor: Colors.red, colorText: Colors.white);
      setState(() => isLoadingAvis = false);
    }
  }

  Future<void> contacterBailleur() async {
    final token = storage.read('token');
    if (token == null) return;

    try {
      final response = await dio.get(
        "https://8f48-137-255-36-216.ngrok-free.app/api/logements/$logementId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        Get.snackbar("Succès", "Vous avez contacté le bailleur.",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Erreur", "Impossible de contacter le bailleur.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur est survenue.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget _buildAvisList() {
    if (isLoadingAvis) {
      return const Center(child: CircularProgressIndicator());
    }

    if (avis.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Aucun avis pour ce logement pour le moment.",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: avis.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final a = avis[index];
        final etudiant = a['etudiant'] ?? {};
        final utilisateur = etudiant['utilisateur'] ?? {};
        final nomEtudiant = "${utilisateur['nom'] ?? 'Anonyme'} ${utilisateur['prenom'] ?? ''}".trim();
        final note = a['note'] ?? 0;
        final commentaire = a['commentaire'] ?? '';
        final dateAvis = a['dateAvis'] ?? '';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            leading: CircleAvatar(
              backgroundColor: KColors.primary.withOpacity(0.15),
              child: const Icon(Icons.person, color: KColors.primary),
            ),
            title: Text(nomEtudiant, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < note ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(commentaire),
                const SizedBox(height: 4),
                Text(
                  dateAvis.isNotEmpty ? DateTime.tryParse(dateAvis)?.toLocal().toString().split(' ')[0] ?? dateAvis : '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = photoBase64 != null
        ? Image.memory(
            base64Decode(photoBase64!),
            fit: BoxFit.cover,
            width: double.infinity,
          )
        : Image.asset(
            "assets/images/logement.jpeg",
            fit: BoxFit.cover,
            width: double.infinity,
          );

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
          // Image principale
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageWidget,
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
                  Text(titre, style: KTypography.h4(context, color: KColors.primary)),
                  const SizedBox(height: 12),
                  Text("Prix : $prix", style: KTypography.h6(context)),
                  const SizedBox(height: 12),
                  Text(widget.logementData['description'] ?? "Aucune description",
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
                          onPressed: contacterBailleur,
                          child: const Text("Contacter",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
          Text("Avis des anciens locataires",
              style: KTypography.h5(context, color: KColors.primary)),
          const SizedBox(height: 12),

          _buildAvisList(),
        ],
      ),
    );
  }
}
