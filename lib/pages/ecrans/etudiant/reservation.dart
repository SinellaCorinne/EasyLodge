import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/paiement.dart';
import '../../../composants/Button.dart';
import '../../../theme/style.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();

  final messageController = TextEditingController();
  final typeLogementController = TextEditingController();
  final prixController = TextEditingController();

  DateTime? selectedDate;
  final dio_package.Dio dio = dio_package.Dio();

  String get formattedDate {
    if (selectedDate == null) return "Sélectionnez une date";
    return DateFormat('dd MMM yyyy').format(selectedDate!);
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> envoyerReservation() async {
    try {
      final response = await dio.post(
        'https://your-api-url.com/reservations', // <-- À remplacer par l’URL réelle
        data: {
          "type_logement": typeLogementController.text.trim(),
          "prix": prixController.text.trim(),
          "date": selectedDate!.toIso8601String(),
          "message": messageController.text.trim(),
        },
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Succès",
          "Réservation envoyée avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => const PaiementPage());
      } else {
        Get.snackbar(
          "Erreur",
          "Erreur lors de la réservation",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue : $e",
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
        title: Text("Réserver le logement", style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ListView(
            children: [
              Text("Studio moderne à Calavi", style: KTypography.h5(context)),
              const SizedBox(height: 6),
              Text("Prix : 15 000 FCFA / mois", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              const SizedBox(height: 20),

              // Type de logement
              TextFormField(
                controller: typeLogementController,
                decoration: const InputDecoration(
                  labelText: "Type de logement",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),

              // Prix
              TextFormField(
                controller: prixController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Prix",
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),

              Text("Choisir une date", style: KTypography.h6(context)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KColors.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black87),
                      ),
                      Icon(Icons.calendar_today_outlined, color: KColors.primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text("Message au bailleur", style: KTypography.h6(context)),
              const SizedBox(height: 8),
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Écrivez votre message ici...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Veuillez écrire un message' : null,
              ),

              const Spacer(),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedDate == null) {
                        Get.snackbar(
                          "Erreur",
                          "Veuillez sélectionner une date",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      envoyerReservation();
                    }
                  },
                  child: const Text(
                    "Envoyer la demande",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
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
