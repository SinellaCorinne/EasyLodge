import 'package:flutter/material.dart';
import '../../../theme/style.dart';

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},{"nom": "Bailleur 1", "dernierMessage": "Bonjour, toujours dispo ?"},
      {"nom": "Bailleur 2", "dernierMessage": "Le logement est meublé."},
      // ... tu peux garder ou varier la liste
    ];

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

class ChatPage extends StatefulWidget {
  final String nom;
  const ChatPage({super.key, required this.nom});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"fromMe": false, "text": "Bonjour, est-ce que le logement est encore disponible ?"},
    {"fromMe": true, "text": "Oui, il est toujours disponible."},
    {"fromMe": false, "text": "Merci, puis-je visiter demain ?"},
  ];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"fromMe": true, "text": controller.text.trim()});
      controller.clear();
    });
    // Ici, tu pourrais ajouter l’envoi réel à un backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: KColors.primary),
        title: Text(
          "Discussion avec ${widget.nom}",
          style: KTypography.h3(context, color: KColors.primary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final align =
                msg["fromMe"] ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final bgColor = msg["fromMe"]
                    ? KColors.primary.withOpacity(0.8)
                    : Colors.grey.shade200;
                final textColor = msg["fromMe"] ? Colors.white : Colors.black87;
                final borderRadius = msg["fromMe"]
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: align,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: borderRadius,
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Zone de saisie
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, -1),
                    blurRadius: 4),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Écris un message...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: KColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
