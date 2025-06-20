import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_app/pages/ecrans/bailleurs/paiements.dart';
import 'package:loge_app/pages/ecrans/bailleurs/reservations_page.dart';
import 'package:loge_app/theme/style.dart';
import 'mes_loges_pages.dart';

class NotificationsPageBailleur extends StatelessWidget {
  NotificationsPageBailleur({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Iconsax.home,
      "title": "Nouveau logement publié",
      "subtitle": "Votre logement a été mis en ligne avec succès.",
      "onTap": () => Get.to(() => MesLogesPages()),
    },
    {
      "icon": Iconsax.user_add,
      "title": "Nouvelle demande de réservation",
      "subtitle": "Vous avez reçu une nouvelle demande.",
      "onTap": () => Get.to(() => ReservationsPage()),
    },
    {
      "icon": Iconsax.money_2,
      "title": "Paiement reçu",
      "subtitle": "Un locataire a effectué un paiement.",
      "onTap": () => Get.to(() => BailleurPaiements()),
    },
    {
      "icon": Icons.cancel_schedule_send,
      "title": "Réservation annulée",
      "subtitle": "Un locataire a annulé sa réservation.",
      "onTap": () => Get.to(() => ReservationsPage()),
    },
    {
      "icon": Icons.warning_amber,
      "title": "Paiement en retard",
      "subtitle": "Un locataire a un paiement en retard.",
      "onTap": () => Get.to(() => BailleurPaiements()),
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
        separatorBuilder: (_, __) => const Divider(indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return InkWell(
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
