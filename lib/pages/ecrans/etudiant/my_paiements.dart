import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/style.dart';



class MyPaiements extends StatelessWidget {
  const MyPaiements({super.key});

  @override
  Widget build(BuildContext context) {
    final paiements = [
      {"montant": 25000, "date": "2025-05-12"},
      {"montant": 30000, "date": "2025-05-18"},
      {"montant": 15000, "date": "2025-05-12"},
      {"montant": 10000, "date": "2025-05-18"},
      {"montant": 20000, "date": "2025-05-12"},
      {"montant": 30000, "date": "2025-05-18"},
      {"montant": 25000, "date": "2025-05-12"},
      {"montant": 21000, "date": "2025-05-18"},
      {"montant": 18000, "date": "2025-05-12"},
      {"montant": 19000, "date": "2025-05-18"},
    ];

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
              .format(DateTime.parse(paiement["date"]as String));

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: KColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.monetization_on_outlined, color: KColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${paiement["montant"]} FCFA",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Le $formattedDate",
                            style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Téléchargement du reçu...")),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, color: KColors.primary),
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
