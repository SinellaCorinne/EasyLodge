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
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        centerTitle: true,
        title: Text("EasyLodge", style: KTypography.h2(context, color: Colors.white)),
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
