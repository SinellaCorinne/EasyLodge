import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/search_pages.dart';
import '../../../composants/Button.dart';
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

  Future<void> envoyerRecherche() async {
    try {
      final response = await dio.post(
        "https://votre-api.com/recherche",
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
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        resultats = response.data['resultats']; // adapte cette clé selon ton API
        Get.to(() => SearchPages(  resultats: [],));
      } else {
        Get.snackbar("Erreur", "Échec de la recherche",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur s'est produite : $e",
          backgroundColor: Colors.red, colorText: Colors.white);
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
        title: Text(
          'Recherche avancée',
          style: KTypography.h3(context, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer une localisation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text('Type de logement', style: KTypography.h5(context, color: KColors.primary)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: typeLogement,
                items: ["Studio", "Chambre", "Colocation"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    typeLogement = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir un type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text('Intervalle de prix (FCFA)', style: KTypography.h5(context, color: KColors.primary)),
              const SizedBox(height: 8),
              Row(
                children: [
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Entrez un nombre valide';
                        }
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Entrez un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez indiquer un nombre';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Entrez un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),

              Center(
                child: Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {Get.to(() => SearchPages(resultats: []));

                      // envoyerRecherche();
                    }
                  },
                  child: const Text(
                    "Rechercher",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
