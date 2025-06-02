import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/bailleurs/paiements.dart';
import '../../../auth_etu/login.dart';
import '../../../theme/style.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final starColor = KColors.primary;
    return Scaffold(
      backgroundColor:Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Mon profil",
              style: KTypography.h3(context, color: KColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("assets/images/college campus-rafiki.png"),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text("Nom du Bailleur", style: KTypography.h5(context)),
          ),
          const SizedBox(height: 25),

        // Menu options styled as Cards for better elevation and feedback
        _buildMenuItem(
          icon: Icons.person,
          title: "Informations personnelles",
          subtitle: "Nom, Email, Téléphone...",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.lock,
          title: "Changer le mot de passe",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.history,
          title: "Historique",
          subtitle: "Locations, paiements, annonces...",
          onTap: () => Get.to(BailleurPaiements()),
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: "Paramètres",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: "Termes et Conditions",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: "Centre d'aide & Forum",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.notifications,
          title: "Notifications",
          onTap: () {},
        ),
          _buildMenuItem(
          icon: Icons.logout,
          title: "Déconnexion",
          onTap: () {
            // Logique de déconnexion ici
            Get.defaultDialog(
              title: "Déconnexion",
              middleText: "Souhaitez-vous vraiment vous déconnecter ?",
              textCancel: "Annuler",
              textConfirm: "Déconnecter",
              confirmTextColor: KColors.primary,
              onConfirm: () => Get.to(Login()),
            );
          },
        ),

        const SizedBox(height: 30),
        Divider(color: Colors.grey[400], thickness: 1),

        const SizedBox(height: 20),
        Text(
          "Donner une note",
          style: KTypography.h6(context).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Stars row with colored stars and spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star_border,
              color: starColor,
              size: 32,
            );
          }),
        ),

        const SizedBox(height: 16),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Laisser un commentaire...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: Text(
              "Publier l'avis",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
        )
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required IconData icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
        Color iconColor = Colors.black}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: KTypography.h5(context,color: KColors.primary)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
    );
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  String? subtitle,
  VoidCallback? onTap,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: KColors.primary.withOpacity(0.1),
        child: Icon(icon, color: KColors.primary),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[600])) : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    ),
  );
}

