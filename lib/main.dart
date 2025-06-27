import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_etu/onboarding.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get_storage/get_storage.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr_FR', null);
  await GetStorage.init(); // Initialiser le stockage local

  // Vérification et demande de permission de localisation
  bool permissionGranted = await _checkPermission();
  if (!permissionGranted) {
    print("⚠️ Permission de localisation refusée ou bloquée.");
    // Ici tu peux afficher une alerte ou rediriger vers une page informative
  }

  runApp(MyApp());
}

Future<bool> _checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Vérifie si les services de localisation sont activés
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  // Vérifie les permissions actuelles
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions refusées définitivement
    return false;
  }

  return true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EasyLodge",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: 
      Onboarding(),
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