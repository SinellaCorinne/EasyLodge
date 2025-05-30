import 'package:get/get.dart';

import '../auth_bailleur/register2.dart';
import '../auth_etu/register.dart';
import '../composants/Button.dart';
import '../composants/i_item.dart';
import 'package:flutter/material.dart';

import '../theme/style.dart';
import 'item.dart';
import 'item1.dart';

class ProfilUser extends StatefulWidget {
  ProfilUser({super.key});

  @override
  State<ProfilUser> createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  @override
  String? selectedRole;

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:  Colors.white,
      body: PageView(
        children: [
          Item1(
            image: "assets/images/House searching-amico.png",
            title: 'Quel est votre profil ?',
            description: "Sélectionnez un rôle pour continuer",
            action: Column(
              children: [
                CheckboxListTile(
                  title: Row(
                    children: [
                      Icon(Icons.school, color: KColors.primary),
                      SizedBox(width: 8),
                      Text("Je suis étudiant"),
                    ],
                  ),
                  value: selectedRole == 'etudiant',
                  onChanged: (bool? value) {
                    setState(() {
                      selectedRole = value! ? 'etudiant' : null;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      Icon(Icons.home_work, color: KColors.primary),
                      SizedBox(width: 8),
                      Text("Je suis bailleur"),
                    ],
                  ),
                  value: selectedRole == 'bailleur',
                  onChanged: (bool? value) {
                    setState(() {
                      selectedRole = value! ? 'bailleur' : null;
                    });
                  },
                ),
                SizedBox(height: 20),
                Button(
                  child: Text("Continuer"),
                  onPressed: selectedRole != null
                      ? () {
                    if (selectedRole == 'etudiant') {
                      Get.to(Register());
                    } else if (selectedRole == 'bailleur') {
                      Get.to(Register2());
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
