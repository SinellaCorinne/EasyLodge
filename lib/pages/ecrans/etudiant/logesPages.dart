import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/logement_page.dart';

import '../../../theme/style.dart';

class Logespages extends StatefulWidget {
  const Logespages({super.key});

  @override
  State<Logespages> createState() => _LogespagesState();
}

class _LogespagesState extends State<Logespages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Liste des logements
            Expanded(
              child: ListView(
                children: [
                  _buildLogementCard(
                    context,
                    image: "assets/images/logement.jpeg",
                    title: "Chambre à Calavi",
                    subtitle: "À 50m du campus",
                  ),
                  const SizedBox(height: 12),
                  _buildLogementCard(
                    context,
                    image: "assets/images/logement.jpeg",
                    title: "Studio à Parakou",
                    subtitle: "Proche du CHD",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogementCard(
      BuildContext context, {
        required String image,
        required String title,
        required String subtitle,
      }) {
    return GestureDetector(
      onTap: () => Get.to(() => LogementPage()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: KTypography.h4(context, color: KColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
