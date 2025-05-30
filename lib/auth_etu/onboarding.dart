import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../composants/Button.dart';
import '../composants/i_item.dart';
import '../composants/item.dart';
import '../composants/onboarding_page.dart';
import '../theme/style.dart';
import 'login.dart';
import 'package:loge_app/composants/profil_user.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController controller = PageController();
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: controller,
        onPageChanged: (value) => setState(() => selected = value),
        children: [
          IItem(
            title: "EasyLodge",
            image: "assets/images/House searching-bro.png",
            description: "Un toit sûr, sans stress.",
            action: Button(
              child: const Text("Ignorer"),
              onPressed: () => controller.jumpToPage(2),
              backgroundColor: const Color(0xFF0B0A5C),
              borderColor: const Color(0xFF0B0A5C),
              foregroundColor: Colors.white,
            ),
          ),
          OnboardingPage(
            title: "EasyLodge",
            image: "assets/images/college students-rafiki.png",
            description: "Un accès simplifié à des logements étudiants sûrs et adaptés.",
          ),
          OnboardingPage(
            title: "EasyLodge",
            image: "assets/images/Realtor-amico.png",
            description: "L’allié digital des bailleurs pour une gestion simple et rapide des logements.",
            action: Column(
              children: [
                Button(
                  child: const Text("Se connecter"),
                  onPressed: () => Get.to(() => const Login()),
                  backgroundColor: const Color(0xFF0B0A5C),
                  borderColor: const Color(0xFF0B0A5C),
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 5),
                Button(
                  child: const Text("S'inscrire"),
                  onPressed: () => Get.to(() =>  ProfilUser()),
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFF0B0A5C),
                  foregroundColor: KColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: selected == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected == index
                    ? KColors.primary
                    : KColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
