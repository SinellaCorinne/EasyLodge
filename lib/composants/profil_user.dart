import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth_etu/register.dart';
import '../auth_etu/register2.dart';
import '../composants/Button.dart';
import '../theme/style.dart';

class ProfilUser extends StatefulWidget {
  const ProfilUser({super.key});

  @override
  State<ProfilUser> createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  String? selectedRole;
  final box = GetStorage();

  void onRoleSelected(String role_user) {
    if (selectedRole != role_user) {
      setState(() {
        selectedRole = role_user;
      });
      box.write('selectedRole', role_user); // Sauvegarder le rôle
    }
  }

  void handleContinue() {
    if (selectedRole == 'Etudiant') {
      Get.to(() => const Register());
    } else if (selectedRole == 'Bailleur') {
      Get.to(() => const Register2());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // Pour désactiver le scroll horizontal
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/House searching-amico.png",
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text(
                  'Quel est votre profil ?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: KColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Sélectionnez un rôle pour continuer",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // RadioListTile pour Etudiant
                RadioListTile<String>(
                  value: 'Etudiant',
                  groupValue: selectedRole,
                  contentPadding: EdgeInsets.zero,
                  activeColor: KColors.primary,
                  title: Row(
                    children: [
                      Icon(Icons.school, color: KColors.primary),
                      const SizedBox(width: 8),
                      const Text("Je suis étudiant(e)"),
                    ],
                  ),
                  onChanged: (value) => onRoleSelected(value!),
                ),

                // RadioListTile pour Bailleur
                RadioListTile<String>(
                  value: 'Bailleur',
                  groupValue: selectedRole,
                  contentPadding: EdgeInsets.zero,
                  activeColor: KColors.primary,
                  title: Row(
                    children: [
                      Icon(Icons.home_work, color: KColors.primary),
                      const SizedBox(width: 8),
                      const Text("Je suis bailleur"),
                    ],
                  ),
                  onChanged: (value) => onRoleSelected(value!),
                ),

                const SizedBox(height: 40),

                Button(
                  child: const Text("Continuer"),
                  onPressed: selectedRole != null ? handleContinue : null,
                  backgroundColor: selectedRole != null ? const Color(0xFF0B0A5C) : Colors.grey,
                  borderColor: selectedRole != null ? const Color(0xFF0B0A5C) : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
