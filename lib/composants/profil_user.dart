import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth_bailleur/register2.dart';
import '../auth_etu/register.dart';
import '../composants/Button.dart';
import '../theme/style.dart';

class ProfilUser extends StatefulWidget {
  ProfilUser({super.key});

  @override
  State<ProfilUser> createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  String? selectedRole;
  final box = GetStorage();

  void onRoleSelected(String role) {
    setState(() {
      selectedRole = role;
    });
    box.write('selectedRole', role); // Stocker le rôle dès la sélection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          // Utilisation d'un widget custom ou remplacer par un Container classique
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/House searching-amico.png", height: 200),
                SizedBox(height: 30),
                Text(
                  'Quel est votre profil ?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: KColors.primary,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Sélectionnez un rôle pour continuer",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Radio buttons pour choisir un rôle unique
                RadioListTile<String>(
                  value: 'etudiant',
                  groupValue: selectedRole,
                  title: Row(
                    children: [
                      Icon(Icons.school, color: KColors.primary),
                      SizedBox(width: 8),
                      Text("Je suis étudiant"),
                    ],
                  ),
                  onChanged: (value) {
                    if (value != null) onRoleSelected(value);
                  },
                ),
                RadioListTile<String>(
                  value: 'bailleur',
                  groupValue: selectedRole,
                  title: Row(
                    children: [
                      Icon(Icons.home_work, color: KColors.primary),
                      SizedBox(width: 8),
                      Text("Je suis bailleur"),
                    ],
                  ),
                  onChanged: (value) {
                    if (value != null) onRoleSelected(value);
                  },
                ),

                SizedBox(height: 40),

                Button(
                  child: Text("Continuer"),
                  onPressed: selectedRole != null
                      ? () {
                    if (selectedRole == 'etudiant') {
                      Get.to(() => Register());
                    } else if (selectedRole == 'bailleur') {
                      Get.to(() => Register2());
                    }
                  }
                      : null,
                  backgroundColor:
                  selectedRole != null ? Color(0xFF0B0A5C) : Colors.grey,
                  borderColor:
                  selectedRole != null ? Color(0xFF0B0A5C) : Colors.grey,
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
