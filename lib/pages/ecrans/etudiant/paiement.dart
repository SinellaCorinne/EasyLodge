import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get_storage/get_storage.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';

class PaiementPage extends StatefulWidget {
  final int reservationId;
  const PaiementPage({super.key, required this.reservationId});

  @override
  State<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  final dio_package.Dio dio = dio_package.Dio();
  final _formKey = GlobalKey<FormState>();
  final List<String> methodes = ["Carte bancaire", "PayPal"];
  String methodeSelectionnee = "Carte bancaire";
  final montantController = TextEditingController(text: "15000");

  Future<void> envoyerPaiement() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "Erreur",
        "Veuillez remplir tous les champs requis",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final storage=GetStorage();
      final token = storage.read("auth_token");
      if (token == null) {
        Get.snackbar(
          "Erreur",
          "Utilisateur non authentifié. Veuillez vous reconnecter.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await dio.post(
        'http://192.168.100.192:8000/api/paiements',
        data: {
          "reservation_id": widget.reservationId,
          "montant": montantController.text.trim(),
          "methode_paie": methodeSelectionnee,
        },
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Succès",
          "Paiement effectué avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.pop(context);
      } else {
        print("${response.statusCode}");
        print("Réponse serveur : ${response.data}");

        Get.snackbar(
          "Erreur",
          "Erreur lors du paiement (${response.statusCode})",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(
        "Une erreur est survenue : $e",);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text(
          "Paiement",
          style: KTypography.h3(context, color: Colors.white),
        ),
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
              Center(
                child: Text(
                  "Montant à payer",
                  style: KTypography.h6(context, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: montantController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Champ requis" : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Ex : 15000",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 32),

              DropdownButtonFormField<String>(
                value: methodeSelectionnee,
                decoration: InputDecoration(
                  labelText: "Méthode de paiement",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                items: methodes
                    .map(
                      (m) => DropdownMenuItem(
                    value: m,
                    child: Text(m, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => methodeSelectionnee = value);
                  }
                },
              ),

              const SizedBox(height: 40),
              Text(
                "Historique des paiements",
                style: KTypography.h5(context, color: KColors.primary),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.payment, color: KColors.primary),
                      title: const Text("Réservation - Studio Calavi", style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text("15 000 FCFA - 01/05/2025"),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.payment, color: KColors.primary),
                      title: const Text("Réservation - Chambre Porto Novo", style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text("12 000 FCFA - 15/04/2025"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Button(
                    onPressed: envoyerPaiement,
                    child: const Text(
                      "Payer",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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
