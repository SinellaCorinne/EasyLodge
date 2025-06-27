import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loge_app/pages/ecrans/etudiant/discussion_page.dart' show DiscussionPage;
import 'package:loge_app/pages/ecrans/etudiant/logesPages.dart';
import '../discussion_page.dart';
import '../../../../auth_etu/login.dart';
import '../../../../composants/header.dart';
import '../../../../composants/logo.dart';
import '../../../../theme/style.dart';
import '../controller/loge_controller.dart';
import '../home_page.dart';
import '../logement_page.dart';
import '../notifications.dart';
import '../page_reservations.dart';
import '../user_page1.dart';

class LogePage extends StatelessWidget {
  final LogeController controller = Get.put(LogeController.instance);

  LogePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(

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
            icon:  Icon(Iconsax.notification,color: Color(0xFF575992),),
            tooltip: 'Notifications',
            onPressed: () {
    Get.to(() =>  NotificationsPageEtudiant());}
          ),
          const SizedBox(width: 8), // Un petit espacement à droite
        ],
      ),

      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: controller.curentIndex,
          children: [
            HomePage(),
            DiscussionsPage(),
            Logespages(),
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
