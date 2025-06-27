import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/details_loge.dart';

class LogementCard extends StatelessWidget {
  final Map<String, String> logement;
  const LogementCard({super.key, required this.logement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to( DetailLoge(logementData: logement,)),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image du logement
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  logement["image"]!,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// Informations
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logement["titre"] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      logement["lieu"] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      logement["prix"] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF1A2A6C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
