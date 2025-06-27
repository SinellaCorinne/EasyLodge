import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio_package;
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';

class ValiderReservation extends StatefulWidget {
  final int reservationId;

  const ValiderReservation({super.key, required this.reservationId});

  @override
  State<ValiderReservation> createState() => _ValiderReservationState();
}

class _ValiderReservationState extends State<ValiderReservation> {
  final dio_package.Dio dio = dio_package.Dio();
  final storage = GetStorage();

  bool isLoading = false;

  void _showConfirmation(BuildContext context, String status) async {
    final confirm = await Get.defaultDialog<bool>(
      title: 'Confirmation',
      middleText: 'Souhaitez-vous vraiment changer le statut en "$status" ?',
      textCancel: 'Annuler',
      textConfirm: 'Confirmer',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm != true) return;

    await _updateStatus(status);
  }

  Future<void> _updateStatus(String status) async {
    print("Soumission...");
    setState(() => isLoading = true);
    final token = storage.read<String>("auth_token");

    if (token == null) {
      Get.snackbar(
        "Erreur",
        "Utilisateur non authentifié. Veuillez vous reconnecter.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await dio.put(
        '${ApiBaseUrl.baseUrl}/reservations/${widget.reservationId}/status',
        data: {
          'statut': status.toLowerCase(), // en minuscule pour backend
        },
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        Get.snackbar(
          "Succès",
          "Statut mis à jour avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.pop(context, true); // retourne true pour indiquer un changement
      } else {
        Get.snackbar(
          "Erreur",
          response.data['message'] ?? "Erreur lors de la mise à jour du statut.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue lors de la mise à jour.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required String status,
  }) {
    return InkWell(
      onTap: isLoading ? null : () => _showConfirmation(context, status),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la Réservation'),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Choisissez une action pour la réservation #${widget.reservationId}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    context: context,
                    label: 'Confirmer la réservation',
                    icon: Icons.check_circle,
                    color: Colors.green,
                    status: 'confirmee',
                  ),
                  _buildActionButton(
                    context: context,
                    label: 'Annuler la réservation',
                    icon: Icons.cancel,
                    color: Colors.red,
                    status: 'annulee',
                  ),
                ],
              ),
      ),
    );
  }
}
