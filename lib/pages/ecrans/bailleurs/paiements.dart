import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class BailleurPaiements extends StatefulWidget {
  const BailleurPaiements({super.key});

  @override
  State<BailleurPaiements> createState() => _BailleurPaiementsState();
}

class _BailleurPaiementsState extends State<BailleurPaiements> {
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
        final List data = response.data['paiements'] ?? [];

        setState(() {
          paiements = data.map<Map<String, dynamic>>((paiement) {
            final locataire = paiement['reservation']?['etudiant']?['utilisateur']?['name'] ?? 'Inconnu';
            final date = paiement['created_at'] ?? DateTime.now().toIso8601String();
            final montant = paiement['montant'] ?? '0';

            return {
              "montant": montant.toString(),
              "date": DateTime.parse(date).toLocal(),
              "locataire": locataire,
              "reference": paiement['reference'] ?? '',
              "statut": paiement['statut'] ?? '',
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
          centerTitle: true,
          title: const Text("Factures"),
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Factures"),
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (paiements.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Factures"),
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text("Aucun paiement trouvé.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Factures"),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: paiements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final paiement = paiements[index];
          final formattedDate = 
              "${paiement['date'].day.toString().padLeft(2,'0')}/"
              "${paiement['date'].month.toString().padLeft(2,'0')}/"
              "${paiement['date'].year}";

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple[100],
                child: const Icon(Icons.money, color: KColors.primary),
              ),
              title: Text(
                "${paiement["montant"]} FCFA",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Date: $formattedDate\nLocataire: ${paiement["locataire"]}",
                style: const TextStyle(height: 1.4),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: KColors.primary),
                onPressed: () {
                  // TODO: Logique de téléchargement du reçu
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Téléchargement du reçu pour ${paiement["locataire"]}")),
                  );
                },
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
