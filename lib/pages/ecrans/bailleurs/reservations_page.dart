import 'package:flutter/material.dart';
import '../../../theme/style.dart';
import 'valider_reservation.dart';

class ReservationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> reservations = [
    {
      'id': 1,
      'statut': 'En attente',
      'logement': {'nom': 'Studio Cotonou', 'adresse': 'Cococodji'}
    },
    {
      'id': 2,
      'statut': 'Confirmée',
      'logement': {'nom': 'Appartement Parakou', 'adresse': 'Zone Universitaire'}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          final logement = reservation['logement'];
          final statut = reservation['statut'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ValiderReservation(reservationId: reservation['id']),
                ),
              );
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
                            logement['nom'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: KColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            logement['adresse'],
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Suppression effectuée'),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      },
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
