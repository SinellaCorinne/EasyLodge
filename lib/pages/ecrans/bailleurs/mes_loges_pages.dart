import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../theme/style.dart';
import 'modif_loge.dart';
import 'details_lodge.dart';
import 'logement.dart';

class MesLogesPages extends StatefulWidget {
  const MesLogesPages({super.key});

  @override
  State<MesLogesPages> createState() => _MesLogesPagesState();
}

class _MesLogesPagesState extends State<MesLogesPages> {
  final Dio dio = Dio();
  final String apiLogementsUrl = "http://192.168.100.192:8000/api/logements";
  String? authToken = "TON_TOKEN_ICI"; // Remplace par le vrai token

  Future<List<Map<String, dynamic>>> fetchLogements() async {
    if (authToken == null) throw Exception("Token non trouvé");

    try {
      final response = await dio.get(
        apiLogementsUrl,
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final logements = response.data['logements'];
        if (logements is List) {
          return logements.cast<Map<String, dynamic>>();
        } else {
          throw Exception("Données invalides");
        }
      } else {
        throw Exception("Erreur HTTP : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de chargement : $e");
      throw Exception("Erreur de connexion");
    }
  }

  void _showDeleteDialog(BuildContext context, int logementId) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("Supprimer ce logement ?"),
            content: const Text("Cette action est irréversible."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Suppression simulée."),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Supprimer"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // ✅ Padding global ici
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchLogements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucun logement trouvé."));
            }

            final logements = snapshot.data!;
            return ListView.separated(
              // ✅ Suppression du padding ici, déjà géré globalement
              itemCount: logements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final annonce = logements[index];
                final isActive = (annonce["statut"] ?? "") == "Disponible";

                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Get.to(() =>
                          DetailLodge(logement: Logement.fromJson(annonce)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              "assets/images/logement.jpeg",
                              width: 100,
                              height: 85,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  annonce["titre"] ?? "Sans titre",
                                  style: KTypography.h4(context).copyWith(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text("Prix : ${annonce["prix"] ?? "N/A"} FCFA",
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.check_circle : Icons
                                          .cancel,
                                      color: isActive ? Colors.green : Colors
                                          .red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isActive ? "Disponible" : "Indisponible",
                                      style: TextStyle(
                                        color: isActive ? Colors.green : Colors
                                            .red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              switch (value) {
                                case "modifier":
                                  Get.to(() =>
                                      LogementEditPage(logementData: annonce));
                                  break;
                                case "desactiver":
                                // À implémenter
                                  break;
                                case "supprimer":
                                  _showDeleteDialog(context, annonce["id"]);
                                  break;
                              }
                            },
                            itemBuilder: (context) =>
                            [
                              const PopupMenuItem(
                                  value: "modifier", child: Text("Modifier")),
                              const PopupMenuItem(value: "desactiver",
                                  child: Text("Désactiver")),
                              const PopupMenuItem(
                                  value: "supprimer", child: Text("Supprimer")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}