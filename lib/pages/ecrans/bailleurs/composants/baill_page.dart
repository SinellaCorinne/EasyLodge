import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loge_app/pages/ecrans/bailleurs/mes_loges_pages.dart';
import 'package:loge_app/pages/ecrans/bailleurs/user_page.dart';
import '../../../../../theme/style.dart';
import '../../../../auth_etu/login.dart';
import '../../../../composants/logo.dart';
import '../controller/baill_controller.dart';
import '../discussions_page.dart';
import '../home_pagee.dart';
import '../notificationsBaill.dart';

class BaillPage extends StatelessWidget {
  final BaillController controller = Get.put(BaillController.instance);

  BaillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: KColors.primary,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Logo(), // Ton widget personnalisé pour le logo
        ),
        centerTitle: true,
        title: Text(
          "EasyLodge",
          style: KTypography.h3(context,color: KColors.primary),
        ),
        actions: [
          IconButton(
            icon:  Icon(Iconsax.notification,),
            tooltip: 'Notifications',
            onPressed: () {
              Get.to(() =>  NotificationsPageBailleur());}
          ),
          const SizedBox(width: 8), // Un petit espacement à droite
        ],
      ),


      backgroundColor: Colors.transparent,
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
          animationDuration: const Duration(milliseconds: 700),
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
