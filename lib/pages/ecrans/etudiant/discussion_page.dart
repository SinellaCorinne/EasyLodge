import 'package:flutter/material.dart';
import '../../../theme/style.dart';
import '../bailleurs/chat_page.dart'; // Même ChatPage réutilisée

class DiscussionsPage extends StatelessWidget {
  const DiscussionsPage({super.key});

  final List<Map<String, String>> conversations = const [
    {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
    {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
    {"nom": "Bailleur 3", "dernierMessage": "C’est possible de visiter demain ?"},
    {"nom": "Bailleur 4", "dernierMessage": "Contacte-moi sur WhatsApp."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Barre de recherche
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher des discussions...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Liste des conversations
            Expanded(
              child: ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: KColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.person, color: KColors.primary),
                    ),
                    title: Text(conv["nom"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(conv["dernierMessage"]!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(nom: conv["nom"]!,destinataireId: index,),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
