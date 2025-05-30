import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/bailleurs/modif_loge.dart';

import '../../../theme/style.dart';

class MesLogesPages extends StatelessWidget {
  MesLogesPages({super.key});

  final List<Map<String, String>> annonces = [
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
    {"titre": "Studio Meublé", "statut": "Disponible"},
    {"titre": "Appartement 3 pièces", "statut": "Pas disponible"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text("Mes annonces", style: TextStyle(color: KColors.primary)),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: annonces.length,
          itemBuilder: (context, index) {
            final annonce = annonces[index];
            final isActive = annonce["statut"] == "Disponible";

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset("assets/images/logement.jpeg",
                      width: 60, height: 60, fit: BoxFit.cover),
                ),
                title: Text(
                  annonce["titre"]!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      annonce["statut"]!,
                      style: TextStyle(
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == "modifier") {
                      Get.to(() => BailleurModificationPage());
                    }
                    // Ajouter les autres actions si nécessaire
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: "modifier", child: Text("Modifier")),
                    const PopupMenuItem(
                        value: "desactiver", child: Text("Désactiver")),
                    const PopupMenuItem(
                        value: "supprimer", child: Text("Supprimer")),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
