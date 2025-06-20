import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/paiement.dart';
import '../../../theme/style.dart';

class PageReservations extends StatelessWidget {
  final List reservations = [
    {
      'id': 1,
      'statut': 'En attente',
      'logement': {
        'nom': 'Chambre universitaire A1',
      }
    },
    {
      'id': 2,
      'statut': 'Confirmée',
      'logement': {
        'nom': 'Studio Résidentiel B5',
      }
    },
    {
      'id': 3,
      'statut': 'Annulée',
      'logement': {
        'nom': 'Appartement Duplex',
      }
    },
  ];

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'Confirmée':
        return Colors.green;
      case 'Annulée':
        return Colors.red;
      case 'En attente':
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String statut) {
    switch (statut) {
      case 'Confirmée':
        return Icons.check_circle;
      case 'Annulée':
        return Icons.cancel;
      case 'En attente':
      default:
        return Icons.hourglass_top;
    }
  }

  void deleteReservation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Voulez-vous supprimer cette réservation ?'),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Supprimer'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Réservation supprimée avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Mes Réservations'),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          final logement = reservation['logement'];
          final statut = reservation['statut'];

          return GestureDetector(
            onTap: () => Get.to(PaiementPage(reservationId: reservation['id'])),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
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
                            logement['nom'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: KColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Statut : ",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
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
                      onPressed: () => deleteReservation(context, reservation['id']),
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
