import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class ChatPage extends StatefulWidget {
  final String nom;
  final int destinataireId;

  const ChatPage({super.key, required this.nom, required this.destinataireId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final Dio dio = Dio();
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final box = GetStorage();
    final token = box.read('auth_token');
    if (token == null) throw Exception("Token non trouvé !");
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<void> fetchMessages() async {
     print("Soumission...");
    try {
      print("Envoi à : ${ApiBaseUrl.baseUrl}/messages");
      final headers = await getAuthHeaders();
      final response = await dio.get(
        '${ApiBaseUrl.baseUrl}/messages/${widget.destinataireId}',
        options: Options(headers: headers),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        setState(() {
          messages = response.data['messages'];
        });
      } else {
        print("Erreur fetch: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur fetch: $e");
    }
  }

  Future<void> sendMessage() async {
    print("Soumission ..");
    final text = controller.text.trim();
    if (text.isEmpty) return;
    try {
      final headers = await getAuthHeaders();
     

    // Ajout immédiat à la liste des messages pour affichage instantané
    setState(() {
      messages.add({
        'contenu': text,
        'is_sender': true,
      });
    });

    controller.clear();
      final response = await dio.post(
        '${ApiBaseUrl.baseUrl}/messages',
        data: {
          'destinataire_id': widget.destinataireId,
          'contenu': text,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
       
        fetchMessages();
      } else {
        print("Erreur envoi: ${response.data}");
      }
    } catch (e) {
      
      print("Erreur envoi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: KColors.primary),
        title: Text(
          "Discussion avec ${widget.nom}",
          style: KTypography.h4(context, color: KColors.primary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isSender = msg['is_sender'] ?? false; // selon ta structure
                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: ChatBubble(
                    text: msg['contenu'],
                    isSender: isSender,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Écris ton message...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: KColors.primary),
                  onPressed: sendMessage, // ✅ Appelle bien la fonction
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      decoration: BoxDecoration(
        color: isSender ? KColors.primary.withOpacity(0.9) : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(0),
          bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: isSender ? Colors.white : Colors.black87),
      ),
    );
  }
}
