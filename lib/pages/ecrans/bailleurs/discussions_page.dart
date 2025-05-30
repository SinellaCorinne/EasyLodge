import 'package:flutter/material.dart';
import '../../../theme/style.dart';
import '../etudiant/discussion_page.dart';

class DiscussionsPage extends StatelessWidget {
  DiscussionsPage({super.key});

  final conversations = [
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    // Ajoute d'autres éléments ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher des discussions..",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: KColors.primary.withOpacity(0.1),
                    child: Icon(Icons.person, color: KColors.primary),
                  ),
                  title: Text(conv["nom"]!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(conv["dernierMessage"]!),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(nom: conv["nom"]!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
