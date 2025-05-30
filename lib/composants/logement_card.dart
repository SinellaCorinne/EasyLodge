
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/details_loge.dart';

class LogementCard extends StatelessWidget {
  final Map<String, String> logement;
  const LogementCard({super.key, required this.logement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(DetailLoge()),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du logement
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(logement["image"]!,
                  height: 110, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(logement["titre"]!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(logement["lieu"]!, style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(logement["prix"]!,
                      style: TextStyle(
                          color: Color(0xFF1A2A6C), fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
