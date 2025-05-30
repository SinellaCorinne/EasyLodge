import 'package:flutter/material.dart';
import '../../../theme/style.dart';

class LogementPage extends StatelessWidget {
  const LogementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // couleur de fond douce
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          Center(
            child: Text(
              "Mon Logement",
              style: KTypography.h3(context, color: KColors.primary),
            ),
          ),
          const SizedBox(height: 20),

          // Carte image avec ombre et arrondi
          Card(
            elevation: 8,
            shadowColor: KColors.primary.withOpacity(0.3),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              "assets/images/logement.jpeg",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // Infos générales dans une carte avec padding
          Card(
            color: Colors.white,
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chambre à Agla",
                    style: KTypography.h3(context, color: KColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Loyer : 18 000 FCFA / mois",
                    style: KTypography.h4(context),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Statut : Réservé",
                    style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section actions avec cartes plus colorées et arrondies
          ...[
            ActionTile(
                icon: Icons.phone,
                label: "Contacter le bailleur",
                onTap: () {}),
            ActionTile(
                icon: Icons.payment, label: "Payer le loyer", onTap: () {}),
            ActionTile(
                icon: Icons.calendar_month,
                label: "Prochaine échéance : 5 juin 2025",
                onTap: () {}),
            ActionTile(
                icon: Icons.water_drop,
                label: "Payer facture eau (SONEB)",
                onTap: () {}),
            ActionTile(
                icon: Icons.flash_on,
                label: "Payer facture électricité (SBEE)",
                onTap: () {}),
          ],

          const SizedBox(height: 32),

          // Section laisser un avis
          Text(
            "Laisser un avis",
            style: KTypography.h5(context),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Écrivez votre avis ici...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: KColors.primary,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 6,
            ),
            child: const Text(
              "Envoyer l'avis",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: KColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: KColors.primary, size: 28),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: KColors.primary),
        onTap: onTap,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
    );
  }
}
