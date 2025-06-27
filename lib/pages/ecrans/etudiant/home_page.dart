import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:loge_app/composants/filtres.dart';
import 'package:loge_app/composants/liste_tile.dart';
import 'package:loge_app/composants/logement_card.dart';
import 'package:loge_app/pages/ecrans/etudiant/recherche_avance.dart';
import 'package:loge_app/theme/style.dart';
import '../../../composants/api_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio dio = Dio();
  final GetStorage storage = GetStorage();
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.trim().isNotEmpty;
      });
    });

    // Test de diagnostic au démarrage
    _diagnosticConnection();
  }

  // Fonction de diagnostic pour tester la connexion
  Future<void> _diagnosticConnection() async {
    try {
      print("🔍 Test de diagnostic de la connexion...");
      final response = await dio.get(
        "${ApiBaseUrl.baseUrl}/health", // ou tout autre endpoint de test
        options: Options(
          headers: {'ngrok-skip-browser-warning': 'true'},
          validateStatus: (status) => true,
        ),
      );
      print("✅ Test de connexion: ${response.statusCode}");
    } catch (e) {
      print("❌ Test de connexion échoué: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchLogementsRecents() async {
    final token = storage.read('auth_token');

    // Vérification du token
    if (token == null || token.toString().isEmpty) {
      print("❌ Token d'authentification manquant");
      throw Exception("Token d'authentification manquant");
    }

    // Diagnostic des informations de connexion
    print("🔍 URL de l'API: ${ApiBaseUrl.baseUrl}/logements");
    print("🔍 Token présent: ${token.toString().substring(0, 20)}...");

    try {
      final response = await dio.get(
        "${ApiBaseUrl.baseUrl}/logements",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          // Accepter tous les codes de statut pour déboguer
          validateStatus: (status) => true,
          // Timeout plus long,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print("STATUS CODE => ${response.statusCode}");
      print("HEADERS => ${response.headers}");
      print("Réponse brute => ${response.data}");

      // Vérifier si la réponse est une page HTML ngrok
      if (response.data is String && response.data.toString().contains('ngrok')) {
        print("❌ Erreur ngrok détectée - Page d'avertissement ngrok");
        throw Exception("Tunnel ngrok non configuré. Visitez l'URL dans un navigateur d'abord.");
      }

      // Gestion des codes d'erreur HTTP
      if (response.statusCode == 401) {
        print("❌ Token invalide ou expiré");
        throw Exception("Session expirée. Reconnectez-vous.");
      }

      if (response.statusCode == 403) {
        print("❌ Accès refusé");
        throw Exception("Accès refusé. Vérifiez vos permissions.");
      }

      if (response.statusCode == 404) {
        print("❌ Endpoint non trouvé");
        throw Exception("Endpoint non trouvé. Vérifiez l'URL de l'API.");
      }

      if (response.statusCode == 500) {
        print("❌ Erreur serveur 500");
        print("❌ Détails erreur serveur: ${response.data}");
        throw Exception("Erreur du serveur (500). Contactez l'administrateur.");
      }

      if (response.statusCode == 502 || response.statusCode == 503) {
        print("❌ Serveur indisponible");
        throw Exception("Serveur temporairement indisponible. Réessayez plus tard.");
      }

      // Vérifier si on a une réponse JSON valide
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          final logements = response.data['logements'];
          if (logements is List) {
            print("✅ ${logements.length} logements récupérés");
            return List<Map<String, dynamic>>.from(logements);
          } else {
            print("⚠️ La clé 'logements' n'est pas une liste: ${response.data}");
            return [];
          }
        } else {
          print("⚠️ Réponse non-JSON: ${response.data}");
          throw Exception("Réponse serveur invalide (non-JSON)");
        }
      } else {
        print("⚠️ Code de statut inattendu: ${response.statusCode}");
        throw Exception("Erreur HTTP ${response.statusCode}");
      }

    } on DioException catch (e) {
      print("❌ Erreur Dio: ${e.type}");
      print("❌ Message: ${e.message}");
      print("❌ Response code: ${e.response?.statusCode}");
      print("❌ Response data: ${e.response?.data}");

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Timeout de connexion. Vérifiez votre réseau.");
        case DioExceptionType.sendTimeout:
          throw Exception("Timeout d'envoi. Connexion trop lente.");
        case DioExceptionType.receiveTimeout:
          throw Exception("Timeout de réception. Le serveur met trop de temps à répondre.");
        case DioExceptionType.connectionError:
          throw Exception("Erreur de connexion. Vérifiez l'URL: ${ApiBaseUrl.baseUrl}");
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 500) {
            throw Exception("Erreur serveur (500). Vérifiez les logs du serveur.");
          }
          throw Exception("Réponse invalide du serveur (${e.response?.statusCode})");
        default:
          throw Exception("Erreur réseau: ${e.message}");
      }
    } catch (e) {
      print("❌ Erreur générale: $e");
      throw Exception("Erreur inattendue: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              "Trouvez votre logement en quelques clics",
              style: KTypography.h3(context, color: KColors.primary)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un logement...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => Get.to(() => const RecherchePage()),
                ),
              ),
            ),
            if (_isSearching) const Filtres(),

            const SizedBox(height: 10),

            if (!_isSearching) _buildSectionTitle(context, "🏠 Logements récents"),
            if (!_isSearching) const SizedBox(height: 12),

            if (!_isSearching)
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchLogementsRecents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              "Erreur de chargement",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.error.toString(),
                              style: TextStyle(color: Colors.red.shade600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: const Text("Réessayer"),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Aucun logement trouvé.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final logements = snapshot.data!;
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: logements.length,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final logement = logements[index];
                        return LogementCard(logement: {
                          "logement_id": logement["logement_id"]?.toString() ?? "",
                          "titre": logement["titre"]?.toString() ?? "Titre non disponible",
                          "lieu": logement["localisation"]?.toString() ?? "Lieu non disponible",
                          "prix": "${logement["prix"]?.toString() ?? 'N/A'} FCFA",
                          "image": (logement["images"] != null &&
                              logement["images"] is List &&
                              logement["images"].isNotEmpty)
                              ? logement["images"][0].toString()
                              : "assets/images/logement.jpeg"
                        });
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),
            _buildSectionTitle(context, "⭐ Logements mieux notés"),
            const SizedBox(height: 12),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchLogementsRecents(), // À remplacer par un endpoint spécifique
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(height: 8),
                          Text(
                            "Erreur de chargement des logements notés",
                            style: TextStyle(color: Colors.red.shade700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: const Text("Réessayer"),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Aucun logement trouvé.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final logements = snapshot.data!;
                return Column(
                  children: logements.map((logement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KListTile(
                        logementData: logement,
                        // Correction du bug: utiliser "images" au lieu de "photo"
                        path: (logement["images"] != null &&
                            logement["images"] is List &&
                            logement["images"].isNotEmpty)
                            ? logement["images"][0].toString()
                            : "assets/images/logement.jpeg",
                        title: logement["titre"]?.toString() ?? "Titre non disponible",
                        subtitle: "${logement["prix"]?.toString() ?? "N/A"} FCFA",
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),
            _buildSectionTitle(context, "💡 Conseils logement", isSmall: true),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
                title: Text("Vérifiez bien l'état du logement avant de réserver."),
                subtitle: Text("Un état des lieux est fortement recommandé."),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {bool isSmall = false}) {
    return Text(
      title,
      style: isSmall
          ? KTypography.h6(context)
          : KTypography.h4(context, color: KColors.primary),
    );
  }
}