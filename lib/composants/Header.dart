import 'package:flutter/material.dart';
import '../theme/style.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onProfileTap;  // Action au clic sur l'icône utilisateur

  // Constructeur du Header, accepte une action sur le clic de l'icône
  Header({Key? key, required this.onProfileTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),  // Icône pour le Drawer
        onPressed: () {
          Scaffold.of(context).openDrawer();  // Ouvre le Drawer
        },
      ),
      title: Text("EasyLodge", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      actions: [
        // Icône utilisateur
        GestureDetector(
          onTap: onProfileTap,  // Action au clic sur l'icône utilisateur
          child: CircleAvatar(
            radius: 20,
            child: Icon(Icons.person, color: Colors.white),  // Icône de l'utilisateur
            backgroundColor: KColors.tertiary,  // Couleur de fond de l'avatar
          ),
        ),
        SizedBox(width: 15),  // Espacement entre l'icône et la fin de la barre
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);  // Hauteur de l'AppBar
}
