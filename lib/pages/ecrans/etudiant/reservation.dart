import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/pages/ecrans/etudiant/page_reservations.dart';
import 'package:loge_app/pages/ecrans/etudiant/paiement.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  final String logementId;
  final String titre;
  final String prix;

  const ReservationPage({
    super.key,
    required this.logementId,
    required this.titre,
    required this.prix,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  DateTime? selectedDate;
  final dio_package.Dio dio = dio_package.Dio();

  String get formattedDate {
    if (selectedDate == null) return "Sélectionnez une date";
    return DateFormat('dd MMM yyyy').format(selectedDate!);
  }

  final storage = GetStorage();

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> envoyerReservation() async {
    if (!_formKey.currentState!.validate() || selectedDate == null) {
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
        'http://192.168.100.192:8000/api/reservations',
        data: {
          "logement_id": widget.logementId,
          "date": selectedDate!.toIso8601String(),
          "message": messageController.text.trim(),
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

      print("Statut HTTP : \${response.statusCode}");
      print("Corps de la réponse : \${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Succès",
          "Réservation envoyée avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() =>  PaiementPage(reservationId: 1,));
      } else {
        print("Erreur lors de la réservation. Statut : \${response.statusCode}");
        print("Réponse serveur : \${response.data}");

        Get.snackbar(
          "Erreur",
          "Erreur lors de la réservation (\${response.statusCode})",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      print("Exception capturée : \$e");
      print("StackTrace : \$stackTrace");

      Get.snackbar(
        "Erreur",
        "Une erreur est survenue : \$e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text("Réserver ",
            style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date de réservation", style: KTypography.h4(context)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text("Message au bailleur (facultatif)", style: KTypography.h4(context)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Entrez un message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child:
                      Button(
                        onPressed: envoyerReservation,
                        child: const Text("Envoyer la réservation"),
                      ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child:
                    Button(child: Text("Voir mes reservations"),onPressed:  () => Get.to(PageReservations()),),

                  ),



                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
