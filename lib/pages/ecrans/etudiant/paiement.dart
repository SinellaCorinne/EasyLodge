import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/pages/ecrans/etudiant/composants/loge_page.dart';
import '../../../composants/Button.dart';
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class PaiementPage extends StatefulWidget {
  final int reservationId;
  final String prix;

  const PaiementPage({
    super.key,
    required this.reservationId,
    required this.prix,
  });

  @override
  State<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  final dio_package.Dio dio = dio_package.Dio();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController prixController = TextEditingController();

  final List<Map<String, dynamic>> methodes = [
    {
      "name": "Mobile Money",
      "icon": Icons.phone_android,
      "fields": ["Numéro de téléphone"]
    },
    {
      "name": "Carte bancaire",
      "icon": Icons.credit_card,
      "fields": ["Numéro de carte", "Date d'expiration", "CVV"]
    },
    {
      "name": "PayPal",
      "icon": Icons.paypal,
      "fields": ["Adresse e-mail PayPal"]
    },
    {
      "name": "Virement bancaire",
      "icon": Icons.account_balance,
      "fields": ["Numéro de compte", "Code IBAN"]
    },
  ];

  String methodeSelectionnee = "Mobile Money";
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    prixController.text = widget.prix;

    for (var methode in methodes) {
      for (var field in methode["fields"]) {
        controllers["${methode["name"]}_$field"] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    prixController.dispose();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> envoyerPaiement() async {
    print("[1] Début de la fonction envoyerPaiement");

    if (!_formKey.currentState!.validate()) {
      print("[2] Le formulaire n'est pas valide");
      return;
    }
    print("[2] Le formulaire est valide");

    final prix = double.tryParse(prixController.text.trim());
    if (prix == null || prix <= 0) {
      print("[3] Prix invalide : ${prixController.text}");
      Get.snackbar(
        "Erreur",
        "Le prix n'est pas valide.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    print("[3] Prix valide : $prix");

    final storage = GetStorage();
    final token = storage.read("auth_token");
    print("[4] Token récupéré : $token");

    if (token == null) {
      print("[5] Aucun token, utilisateur non connecté");
      Get.snackbar(
        "Erreur",
        "Vous n'êtes pas connecté.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      print("[6] Envoi de la requête de paiement...");

      final response = await dio.post(
        '${ApiBaseUrl.baseUrl}/paiements',
        data: {
          "reservation_id": widget.reservationId,
          "montant": prixController.text.trim(),
          "methode_paie": methodeSelectionnee,
        },
        options: dio_package.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("[7] Réponse reçue : ${response.statusCode} - ${response.data}");

      if (response.statusCode == 201) {
        print("[8] Paiement effectué avec succès");
        Get.defaultDialog(
          title: "Paiement",
          content: Column(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 12),
              Text("Paiement enregistré avec succès"),
            ],
          ),
          confirm: Button(
            child: const Text("OK"),
            onPressed: () => Get.to(() => LogePage()),
          ),
        );
      } else {
        print("[9] Paiement échoué : ${response.statusMessage}");
        Get.snackbar(
          "Erreur",
          "Échec du paiement: ${response.statusMessage}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("[10] Exception attrapée : $e");
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedMethod = methodes.firstWhere(
      (methode) => methode["name"] == methodeSelectionnee,
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text("Paiement", style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Montant à payer", style: KTypography.h6(context)),
              const SizedBox(height: 8),
              TextFormField(
                controller: prixController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ex: 10000",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  final montant = double.tryParse(value ?? "");
                  if (montant == null || montant <= 0) {
                    return "Montant invalide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text("Méthode de paiement", style: KTypography.h6(context)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: methodeSelectionnee,
                items: methodes.map((methode) {
                  return DropdownMenuItem<String>(
                    value: methode["name"],
                    child: Row(
                      children: [
                        Icon(methode["icon"], color: KColors.primary),
                        const SizedBox(width: 10),
                        Text(methode["name"]),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => methodeSelectionnee = val!);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...selectedMethod["fields"].map<Widget>((field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field, style: KTypography.h6(context)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controllers["${methodeSelectionnee}_$field"],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Ce champ est requis"
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: envoyerPaiement,
                  label: Text(
                    "Valider le paiement",
                    style: KTypography.h5(context, color: Colors.white),
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
