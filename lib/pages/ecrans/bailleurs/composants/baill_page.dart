import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loge_app/pages/ecrans/bailleurs/mes_loges_pages.dart';
import 'package:loge_app/pages/ecrans/bailleurs/user_page.dart';
import '../../../../../theme/style.dart';
import '../../../../auth_etu/login.dart';
import '../controller/baill_controller.dart';
import '../discussions_page.dart';
import '../home_pagee.dart';

class BaillPage extends StatelessWidget {
  final BaillController controller = Get.put(BaillController.instance);

  BaillPage({super.key});

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
                controller.updateCurentIndex(3); // Va à la page "Moi"
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Navigue vers une page de paramètres si nécessaire
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
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
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: controller.curentIndex,
          children: [
            HomePagee(),
            DiscussionsPage(),
            MesLogesPages(),
            UserPage(),
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
