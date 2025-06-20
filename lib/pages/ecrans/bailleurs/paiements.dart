import 'package:flutter/material.dart';

import '../../../theme/style.dart';

class BailleurPaiements extends StatelessWidget {
  const BailleurPaiements({super.key});

  @override
  Widget build(BuildContext context) {
    final paiements = [
      {"montant": "25000", "date": "12/05/2025", "locataire": "Jean Dupont"},
      {"montant": "30000", "date": "18/05/2025", "locataire": "Alice Zola"},
      {"montant": "15000", "date": "12/05/2025", "locataire": "Jean Dupont"},
      {"montant": "10000", "date": "18/05/2025", "locataire": "Alice Zola"},
      {"montant": "20000", "date": "12/05/2025", "locataire": "Jean Dupont"},
      {"montant": "30000", "date": "18/05/2025", "locataire": "Alice Zola"},
      {"montant": "25000", "date": "12/05/2025", "locataire": "Jean Dupont"},
      {"montant": "21000", "date": "18/05/2025", "locataire": "Alice Zola"},
      {"montant": "18000", "date": "12/05/2025", "locataire": "Jean Dupont"},
      {"montant": "19000", "date": "18/05/2025", "locataire": "Alice Zola"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Factures"),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: paiements.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final paiement = paiements[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple[100],
                child: Icon(Icons.money, color: KColors.primary),
              ),
              title: Text(
                "${paiement["montant"]} FCFA",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Date: ${paiement["date"]}\nLocataire: ${paiement["locataire"]}",
                style: TextStyle(height: 1.4),
              ),
              trailing: IconButton(
                icon: Icon(Icons.download_rounded, color: KColors.primary),
                onPressed: () {
                  // Logique de téléchargement ici
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
