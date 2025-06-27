import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio_package;
import '../../../composants/api_url.dart';
import '../../../theme/style.dart';
import 'valider_reservation.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final dio_package.Dio dio = dio_package.Dio();
  final storage = GetStorage();

  List<dynamic> reservations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
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
      final response = await dio.get(
        '${ApiBaseUrl.baseUrl}/reservations',
        options: dio_package.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          reservations = response.data['reservations'];
          isLoading = false;
        });
      } else {
        Get.snackbar(
          "Erreur",
          "Impossible de récupérer les réservations.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() => isLoading = false);
      }
    } catch (e) {
     
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue lors de la récupération.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'confirmée':
      case 'confirmee':
        return Colors.green;
      case 'annulée':
      case 'annulee':
        return Colors.red;
      case 'en attente':
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String statut) {
    switch (statut.toLowerCase()) {
      case 'confirmée':
      case 'confirmee':
        return Icons.check_circle;
      case 'annulée':
      case 'annulee':
        return Icons.cancel;
      case 'en attente':
      default:
        return Icons.hourglass_top;
    }
  }

  Future<void> deleteReservation(int id) async {
    print("Soumission...");
    final confirm = await Get.defaultDialog<bool>(
      title: 'Confirmation',
      middleText: 'Voulez-vous supprimer cette réservation ?',
      textCancel: 'Annuler',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm != true) return;

    final token = storage.read<String>("auth_token");
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
      final response = await dio.delete(
        '${ApiBaseUrl.baseUrl}reservations/$id',
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
          "Réservation supprimée avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() {
          reservations.removeWhere((r) => r['reservation_id'] == id);
        });
      } else {
        Get.snackbar(
          "Erreur",
          response.data['message'] ?? "Impossible de supprimer la réservation.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue lors de la suppression.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? Center(
                  child: Text(
                    "Aucune réservation trouvée.",
                    style: KTypography.h4(context, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    final logement = reservation['logement'] ?? {};
                    final statut = (reservation['statut'] ?? '').toString();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ValiderReservation(reservationId: reservation['reservation_id']),
                          ),
                        ).then((value) {
                          // Après retour, rafraîchir la liste
                          fetchReservations();
                        });
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: _getStatusColor(statut).withOpacity(0.15),
                                child: Icon(
                                  _getStatusIcon(statut),
                                  color: _getStatusColor(statut),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      logement['nom'] ?? "Nom indisponible",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: KColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      logement['adresse'] ?? "Adresse indisponible",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text("Statut : ", style: TextStyle(color: Colors.grey[700])),
                                        Text(
                                          statut,
                                          style: TextStyle(
                                            color: _getStatusColor(statut),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => deleteReservation(reservation['reservation_id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}