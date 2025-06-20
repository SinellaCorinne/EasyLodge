import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../theme/style.dart';
import 'edit_infos.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key});

  final dio = Dio();

  Future<Map<String, dynamic>> fetchUserInfo() async {
    await GetStorage.init();
    final box = GetStorage();
    final token = box.read('auth_token');

    if (token == null) {
      throw Exception("Token introuvable");
    }

    try {
      final response = await dio.get(
        'http://192.168.100.192:8000/api/profile',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      print("Réponse HTTP: ${response.statusCode}");
      print("Données reçues: ${response.data}");

      final data = response.data;

      // Sécurité sur le type
      if (data is! Map) {
        throw Exception("Réponse invalide du serveur.");
      }

      if (data['status'] == true && data.containsKey('user')) {
        return Map<String, dynamic>.from(data['user']);
      } else {
        throw Exception("Données utilisateur introuvables ou statut invalide.");
      }
    } catch (e) {
      String errorMessage = 'Erreur inconnue';

      if (e is DioError) {
        if (e.response != null) {
          errorMessage = 'Erreur serveur : ${e.response?.data}';
        } else {
          errorMessage = 'Erreur réseau : ${e.message}';
        }
      } else {
        errorMessage = e.toString();
      }

      print("Erreur attrapée : $errorMessage");

      throw Exception(errorMessage); // propager pour affichage dans le widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Mon Profil", style: KTypography.h2(context, color: Colors.white)),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text("Aucune connexion établie."));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Center(child: Text("Chargement en cours..."));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erreur : ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                final nom = user['nom'] ?? '';
                final prenom = user['prenom'] ?? '';
                final email = user['email'] ?? '';
                final telephone = user['tel'] ?? '';

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15,),
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/images/college campus-rafiki.png"),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            InfoTile(icon: Iconsax.user, title: "Nom complet", value: "$nom $prenom"),
                            const SizedBox(height: 16),
                            InfoTile(icon: Iconsax.call, title: "Téléphone", value: telephone),
                            const SizedBox(height: 16),
                            InfoTile(icon: Iconsax.sms, title: "Email", value: email),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: KColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () => Get.to(const EditUserInfoPage()),
                                icon: const Icon(Iconsax.edit, color: Colors.white),
                                label: Text(
                                  "Modifier mes informations",
                                  style: KTypography.h6(context, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("Données introuvables."));
              }
          }
        },
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(icon, color: KColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: KTypography.h5(context, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: KTypography.h6(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
