import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../composants/api_url.dart';
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
  final String apiLogementsUrl = "${ApiBaseUrl.baseUrl}/logements/mes-logements";
  final GetStorage storage = GetStorage();

  String? token;

  Future<void> _loadToken() async {
    token = storage.read('auth_token');
    if (token == null) {
      Get.snackbar(
        "Erreur",
        "Token non trouvé",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchLogements() async {
    await _loadToken();

    try {
      final response = await dio.get(
        apiLogementsUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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

  Future<void> deleteLogement(int logementId) async {
    final currentToken = storage.read('auth_token');
    if (currentToken == null) {
      Get.snackbar(
        "Erreur",
        "Token non trouvé",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final url = "$apiLogementsUrl/$logementId";

    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $currentToken'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        Get.snackbar(
          "Succès",
          "Logement supprimé avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        setState(() {}); // rafraîchir la liste
      } else {
        Get.snackbar(
          "Erreur",
          response.data['message'] ?? "Erreur lors de la suppression",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      
      Get.snackbar(
        "Erreur",
        "Erreur de connexion au serveur",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, int logementId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer ce logement ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await deleteLogement(logementId);
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
        padding: const EdgeInsets.all(16.0),
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
                      Get.to(() => DetailLodge(logement: Logement.fromJson(annonce)));
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
                            child: annonce["images"] != null &&
                                    (annonce["images"] as List).isNotEmpty
                                ? Image.network(
                                    annonce["images"][0],
                                    width: 100,
                                    height: 85,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
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
                                  style: KTypography.h4(context)
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text("Prix : ${annonce["prix"] ?? "N/A"} FCFA",
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.check_circle : Icons.cancel,
                                      color: isActive ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isActive ? "Disponible" : "Indisponible",
                                      style: TextStyle(
                                        color: isActive ? Colors.green : Colors.red,
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
                                  Get.to(() => LogementEditPage(logementData: annonce));
                                  break;
                                case "supprimer":
                                  _showDeleteDialog(context, annonce["logement_id"]);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: "modifier", child: Text("Modifier")),
                              const PopupMenuItem(value: "supprimer", child: Text("Supprimer")),
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
