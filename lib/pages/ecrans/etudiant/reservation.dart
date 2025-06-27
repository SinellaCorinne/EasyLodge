import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loge_app/pages/ecrans/etudiant/page_reservations.dart';
import 'package:loge_app/pages/ecrans/etudiant/paiement.dart';
import '../../../composants/Button.dart';
import '../../../composants/api_url.dart';
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

  final storage = GetStorage();

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

    try {
      print("=== DÉBUT DE LA SOUMISSION ===");
      print("URL: ${ApiBaseUrl.baseUrl}/reservations");
      print("Données envoyées:");
      print("- logement_id: ${widget.logementId}");
      print("- date: ${selectedDate!.toIso8601String()}");
      print("- message: ${messageController.text.trim()}");
      print("- token: ${token.substring(0, 20)}..."); // Affiche seulement les premiers caractères du token
      
      final response = await dio.post(
        '${ApiBaseUrl.baseUrl}/reservations',
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
      print("logement_id envoyé: '${widget.logementId}'");

      print("=== RÉPONSE DU SERVEUR ===");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Data complet: ${response.data}");
      
      // Affichage détaillé des données de réponse
      if (response.data != null) {
        print("=== ANALYSE DES DONNÉES ===");
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          data.forEach((key, value) {
            print("$key: $value (type: ${value.runtimeType})");
          });
          
          // Vérification de la structure de réservation
          if (data.containsKey('reservation')) {
            print("=== DÉTAILS RÉSERVATION ===");
            final reservation = data['reservation'];
            if (reservation is Map) {
              reservation.forEach((key, value) {
                print("reservation.$key: $value");
              });
            } else {
              print("reservation n'est pas un Map: $reservation");
            }
          }
        }
      }
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("=== SUCCÈS DE LA RÉSERVATION ===");
        
        // Récupération sécurisée de l'ID de réservation
        dynamic reservationId;
        
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          
          // Plusieurs façons de récupérer l'ID
          if (data.containsKey('reservation') && data['reservation'] is Map) {
            final reservation = data['reservation'] as Map<String, dynamic>;
            reservationId = reservation['reservation_id'] ?? 
                          reservation['id'] ?? 
                          reservation['reservationId'];
          } else if (data.containsKey('id')) {
            reservationId = data['id'];
          } else if (data.containsKey('reservation_id')) {
            reservationId = data['reservation_id'];
          }
        }
        
        print("ID de réservation récupéré: $reservationId");
        
        // Utilisation d'un ID par défaut si aucun n'est trouvé
        final finalReservationId = reservationId ?? 1;
        
        Get.snackbar(
          "Succès",
          "Réservation envoyée avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigation corrigée vers la page Paiement
        print("Navigation vers PaiementPage avec ID: $finalReservationId");
        Get.to(() => PaiementPage(
          reservationId: finalReservationId,
          prix: widget.prix,
        ));
        
      } else {
        print("=== ERREUR DE STATUT ===");
        print("Status: ${response.statusCode}");
        print("Message d'erreur possible: ${response.data}");
        
        String errorMessage = "Erreur lors de la réservation (${response.statusCode})";
        
        // Tentative d'extraction du message d'erreur du serveur
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('message')) {
            errorMessage = data['message'].toString();
          } else if (data.containsKey('error')) {
            errorMessage = data['error'].toString();
          } else if (data.containsKey('errors')) {
            errorMessage = data['errors'].toString();
          }
        }
        
        Get.snackbar(
          "Erreur",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("=== EXCEPTION CAPTURÉE ===");
      print("Type d'erreur: ${e.runtimeType}");
      print("Message d'erreur: $e");
      
      if (e is dio_package.DioException) {
        print("=== DÉTAILS DIO EXCEPTION ===");
        print("Type: ${e.type}");
        print("Message: ${e.message}");
        print("Response: ${e.response?.data}");
        print("Status Code: ${e.response?.statusCode}");
      }
      
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
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: KColors.primary,
        title: Text("Réserver", style: KTypography.h3(context, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              const SizedBox(height: 30),
              Center(
                child: Button(
                  onPressed: envoyerReservation, // Correction ici - suppression du ()=>
                  child: const Text("Envoyer la réservation"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Button(
                  child: const Text("Voir mes réservations"),
                  onPressed: () => Get.to(() => PageReservations()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}