import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_etu/onboarding.dart';

void main() async {
  await GetStorage.init(); // Initialiser le stockage local
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EasyLodge",
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.white, // Couleur de fond pour toutes les pages
        textTheme: GoogleFonts
            .poppinsTextTheme(), // Utilisez Google Fonts si nécessaire
        // Autres configurations de thème
      ),
      home: Onboarding(),
    );
  }
}

// drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: KColors.primary,
//               ),
//               child: Text(
//                 'EasyLodge',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Iconsax.profile_circle),
//               title: const Text('Mon profil'),
//               onTap: () {
//                 controller.updateCurentIndex(3); // Aller à l'onglet "Moi"
//                 Navigator.pop(context); // Fermer le Drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Paramètres'),
//               onTap: () {
//                 // Ajoute ta logique de navigation ici si besoin
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Déconnexion'),
//               onTap: () {
//                 Get.defaultDialog(
//                   title: "Déconnexion",
//                   middleText: "Souhaitez-vous vraiment vous déconnecter ?",
//                   textCancel: "Annuler",
//                   textConfirm: "Déconnecter",
//                   confirmTextColor: Colors.white,
//                   onConfirm: () => Get.to(Login())
//                 );
//               },
//             ),
//           ],
//         ),
//       ),