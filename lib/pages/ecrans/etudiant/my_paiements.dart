import 'package:dio/dio.dart' as dio_package;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class MyPaiements extends StatefulWidget {
  const MyPaiements({super.key});

  @override
  State<MyPaiements> createState() => _MyPaiementsState();
}

class _MyPaiementsState extends State<MyPaiements> {
  final dio_package.Dio dio = dio_package.Dio();
  final storage = GetStorage();

  List<Map<String, dynamic>> paiements = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPaiements();
  }

  Future<void> fetchPaiements() async {
    final token = storage.read("auth_token");

    if (token == null) {
      setState(() {
        error = "Utilisateur non authentifié.";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await dio.get(
        '${ApiBaseUrl.baseUrl}/paiements',
        options: dio_package.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        // On récupère la liste des paiements depuis la réponse
        final List data = response.data['paiements'] ?? [];
        // On mappe la liste en List<Map<String, dynamic>>
        setState(() {
          paiements = data.map<Map<String, dynamic>>((paiement) {
            return {
              "montant": paiement['montant'] ?? 0,
              "date": paiement['created_at'] ?? DateTime.now().toIso8601String(),
              "reference": paiement['reference'] ?? '',
              "statut": paiement['statut'] ?? '',
              // ajoute d'autres champs si besoin
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Erreur lors de la récupération des paiements.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Erreur réseau : $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Factures"),
          backgroundColor: KColors.primary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Factures"),
          backgroundColor: KColors.primary,
        ),
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (paiements.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Factures"),
          backgroundColor: KColors.primary,
        ),
        body: const Center(
          child: Text("Aucun paiement trouvé."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Mes Factures"),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: paiements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final paiement = paiements[index];
          final formattedDate = DateFormat('dd MMM yyyy', 'fr_FR')
              .format(DateTime.parse(paiement["date"] as String));

          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: KColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.monetization_on_outlined,
                        color: KColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${paiement["montant"]} FCFA",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Le $formattedDate",
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13)),
                        Text("Référence: ${paiement["reference"]}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic)),
                        Text("Statut: ${paiement["statut"]}",
                            style: TextStyle(
                                color: paiement["statut"] == "complete"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Téléchargement du reçu...")),
                      );
                    },
                    icon: const Icon(Icons.download_rounded,
                        color: KColors.primary),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
