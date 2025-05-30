import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loge_app/pages/ecrans/etudiant/discussion_page.dart' show DiscussionPage;

import '../../../../auth_etu/login.dart';
import '../../../../composants/header.dart';
import '../../../../theme/style.dart';
import '../controller/loge_controller.dart';
import '../home_page.dart';
import '../logement_page.dart';
import '../user_page1.dart';

class LogePage extends StatelessWidget {
  final LogeController controller = Get.put(LogeController.instance);

  LogePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        centerTitle: true,
        title: Text("EasyLodge", style: KTypography.h2(context, color: Colors.white)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: KColors.primary,
              ),
              child: Text(
                'EasyLodge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.profile_circle),
              title: const Text('Mon profil'),
              onTap: () {
                controller.updateCurentIndex(3); // Aller à l'onglet "Moi"
                Navigator.pop(context); // Fermer le Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Ajoute ta logique de navigation ici si besoin
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Get.defaultDialog(
                  title: "Déconnexion",
                  middleText: "Souhaitez-vous vraiment vous déconnecter ?",
                  textCancel: "Annuler",
                  textConfirm: "Déconnecter",
                  confirmTextColor: Colors.white,
                  onConfirm: () => Get.to(Login())
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: controller.curentIndex,
          children: [
            HomePage(),
            DiscussionPage(),
            LogementPage(),
            UserPage1(),
          ],
        )),
      ),
      bottomNavigationBar: Obx(
            () => CurvedNavigationBar(
          index: controller.curentIndex,
          height: 60,
          backgroundColor: Colors.white,
          color: KColors.primary,
          buttonBackgroundColor: KColors.primary,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            controller.updateCurentIndex(index);
          },
          items: const <Widget>[
            Icon(Icons.home_outlined, size: 30, color: Colors.white),
            Icon(Iconsax.message, size: 30, color: Colors.white),
            Icon(Icons.other_houses_sharp, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
