import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/theme/style.dart';
import 'package:loge_app/pages/ecrans/etudiant/discussion_page.dart';
import 'package:loge_app/pages/ecrans/etudiant/page_reservations.dart';
import 'package:loge_app/pages/ecrans/etudiant/paiement.dart';
import 'my_paiements.dart';

class NotificationsPageEtudiant extends StatelessWidget {
  NotificationsPageEtudiant({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Iconsax.message,
      "title": "Nouveau message",
      "subtitle": "Vous avez reçu un nouveau message.",
      "onTap": () => Get.to(() => DiscussionsPage()),
    },
    {
      "icon": Icons.receipt_long,
      "title": "Paiement effectué",
      "subtitle": "Votre reçu est disponible.",
      "onTap": () => Get.to(() => const MyPaiements()),
    },
    {
      "icon": Icons.warning_amber_rounded,
      "title": "Paiement en retard",
      "subtitle": "Vous avez un paiement en attente.",
      "onTap": () => Get.to(() => const PaiementPage(reservationId: 1,prix: "25000",)),
    },
    {
      "icon": Icons.cancel,
      "title": "Réservation refusée",
      "subtitle": "Votre demande a été refusée.",
      "onTap": () => Get.to(() => PageReservations()),
    },
    {
      "icon": Icons.check_circle_outline,
      "title": "Réservation confirmée",
      "subtitle": "Votre réservation a été validée.",
      "onTap": () => Get.to(() => PageReservations()),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
        title: Text("Notifications", style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 0, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return GestureDetector(
            onTap: notif["onTap"],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: KColors.primary.withOpacity(0.1),
                child: Icon(notif["icon"], color: KColors.primary),
              ),
              title: Text(
                notif["title"],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                notif["subtitle"],
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          );
        },
      ),
    );
  }
}
