import 'package:flutter/material.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';

class PaiementPage extends StatefulWidget {
  const PaiementPage({super.key});

  @override
  State<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  final List<String> methodes = ["Carte bancaire", "PayPal"];
  String methodeSelectionnee = "Carte bancaire";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text(
          "Paiement",
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Montant à payer bien mis en avant
            Center(
              child: Text(
                "Montant à payer",
                style: KTypography.h6(context, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "15 000 FCFA",
                style: KTypography.h2(context, color: KColors.primary),
              ),
            ),

            const SizedBox(height: 32),

            // Sélecteur de méthode
            DropdownButtonFormField<String>(
              value: methodeSelectionnee,
              decoration: InputDecoration(
                labelText: "Méthode de paiement",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              items: methodes
                  .map(
                    (m) => DropdownMenuItem(
                  value: m,
                  child: Text(
                    m,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    methodeSelectionnee = value;
                  });
                }
              },
            ),

            const SizedBox(height: 40),

            // Historique des paiements
            Text(
              "Historique des paiements",
              style: KTypography.h5(context, color: KColors.primary),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.payment, color: KColors.primary),
                    title: Text("Réservation - Studio Calavi",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("15 000 FCFA - 01/05/2025"),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.payment, color: KColors.primary),
                    title: Text("Réservation - Chambre Porto Novo",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("12 000 FCFA - 15/04/2025"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Bouton Payer centré
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: Button(
                  onPressed: () {
                    // Action de paiement
                  },
                  child: Text(
                    "Payer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
