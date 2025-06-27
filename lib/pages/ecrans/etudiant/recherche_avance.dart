import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loge_app/pages/ecrans/etudiant/search_pages.dart';
import '../../../composants/Button.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class RecherchePage extends StatefulWidget {
  const RecherchePage({super.key});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  final _formKey = GlobalKey<FormState>();
  final localisationController = TextEditingController();
  final prixMinController = TextEditingController();
  final prixMaxController = TextEditingController();
  final chambreController = TextEditingController();
  final Dio dio = Dio();

  String? typeLogement = "Studio";
  List<dynamic> resultats = [];
  String _positionInfo = "Chargement de votre position...";

  @override
  void initState() {
    super.initState();
    _useLocation();
  }

  Future<void> _useLocation() async {
    try {
      Position pos = await _getCurrentLocation();
      List<Placemark> places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isNotEmpty) {
        final p = places.first;
        setState(() {
          _positionInfo =
              "Position actuelle : ${p.locality}, ${p.country}\nLat : ${pos.latitude}, Lon : ${pos.longitude}";
        });
      }
    } catch (e) {
      setState(() => _positionInfo = "Impossible d'obtenir la position.");
    }
  }

  Future<bool> _checkPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.whileInUse || perm == LocationPermission.always;
  }

  Future<Position> _getCurrentLocation() async {
    if (!await _checkPermission()) throw Exception('Permissions non accordées');
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> envoyerRecherche() async {
    if (!_formKey.currentState!.validate()) return;

    await GetStorage.init();
    final token = GetStorage().read('auth_token');
    if (token == null) {
      Get.snackbar("Erreur", "Token non trouvé", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final resp = await dio.post(
        "${ApiBaseUrl.baseUrl}/logements/search",
        data: {
          "localisation": localisationController.text.trim(),
          "type_logement": typeLogement,
          "prix_min": int.tryParse(prixMinController.text.trim()) ?? 0,
          "prix_max": int.tryParse(prixMaxController.text.trim()) ?? 0,
          "chambres": int.tryParse(chambreController.text.trim()) ?? 0,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (resp.statusCode == 200) {
        resultats = resp.data['resultats'];
        Get.to(() => SearchPages(resultats: resultats));
      } else {
        Get.snackbar("Erreur", "Échec de la recherche", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur s'est produite : $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    localisationController.dispose();
    prixMinController.dispose();
    prixMaxController.dispose();
    chambreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        elevation: 2,
        title: Text('Recherche avancée', style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_positionInfo, style: KTypography.h5(context, color: KColors.primary)),
            const SizedBox(height: 16),
            Text('Localisation', style: KTypography.h5(context, color: KColors.primary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: localisationController,
              decoration: InputDecoration(
                hintText: 'Ex : Calavi, Cotonou...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Veuillez entrer une localisation' : null,
            ),
            const SizedBox(height: 20),
            Text('Type de logement', style: KTypography.h5(context, color: KColors.primary)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: typeLogement,
              items: ["Studio", "Chambre", "Colocation"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => typeLogement = v),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (v) => v == null || v.isEmpty ? 'Veuillez choisir un type' : null,
            ),
            const SizedBox(height: 20),
            Text('Intervalle de prix (FCFA)', style: KTypography.h5(context, color: KColors.primary)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: prixMinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Prix min',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Champ requis';
                    if (int.tryParse(v) == null) return 'Entrez un nombre valide';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: prixMaxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Prix max',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Champ requis';
                    if (int.tryParse(v) == null) return 'Entrez un nombre valide';
                    return null;
                  },
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Text('Nombre de chambres', style: KTypography.h5(context, color: KColors.primary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: chambreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ex : 1, 2...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Veuillez indiquer un nombre';
                if (int.tryParse(v) == null) return 'Entrez un nombre valide';
                return null;
              },
            ),
            const SizedBox(height: 36),
            Center(
              child: Button(
                onPressed: envoyerRecherche,
                child: const Text("Rechercher", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
