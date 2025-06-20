import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/userInfos/centre_aide.dart';
import 'package:loge_app/pages/ecrans/etudiant/userInfos/notifications.dart';
import 'package:loge_app/pages/ecrans/etudiant/userInfos/termes.dart';
import 'package:loge_app/pages/ecrans/etudiant/userInfos/personnaliser_page.dart';
import '../../../auth_etu/login.dart';
import '../../../theme/style.dart';
import '../bailleurs/userInfos/user_infos_page.dart';
import 'my_paiements.dart';

class UserPage1 extends StatelessWidget {
  const UserPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0), // ✅ Padding global uniforme
        child: ListView(
          children: [
            // ✅ Avatar stylisé
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: KColors.primary.withOpacity(0.1),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/college campus-rafiki.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),

            // ✅ Nom utilisateur

            const SizedBox(height: 15),

            // ✅ Menu items stylisés
            _buildMenuItem(
              icon: Icons.person,
              title: "Informations personnelles",
              subtitle: "Nom, Email, Téléphone...",
              onTap: () => Get.to(UserInfoPage()),
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: "Historique",
              subtitle: "Locations, paiements, annonces...",
              onTap: () => Get.to(MyPaiements()),
            ),
            _buildMenuItem(
              icon: Icons.description,
              title: "Termes et Conditions",
              onTap: () => Get.to(TermesConditionsPage()),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Centre d'aide & Forum",
              onTap: () => Get.to(PagesAidePage()),
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () => Get.to(NotificationsPage()),
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: "Déconnexion",
              onTap: () {
                Get.defaultDialog(
                  title: "Déconnexion",
                  middleText: "Souhaitez-vous vraiment vous déconnecter ?",
                  textCancel: "Annuler",
                  textConfirm: "Déconnecter",
                  confirmTextColor: Colors.white,
                  buttonColor: KColors.primary,
                  onConfirm: () => Get.to(const Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: KColors.primary.withOpacity(0.15),
          child: Icon(icon, color: KColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
