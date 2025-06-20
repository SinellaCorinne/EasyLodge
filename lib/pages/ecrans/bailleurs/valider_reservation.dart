import 'package:flutter/material.dart';
import '../../../theme/style.dart';

class ValiderReservation extends StatelessWidget {
  final int reservationId;

  const ValiderReservation({super.key, required this.reservationId});

  void _showConfirmation(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Souhaitez-vous vraiment changer le statut en "$status" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KColors.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Statut mis à jour : "$status"'),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required String status,
  }) {
    return InkWell(
      onTap: () => _showConfirmation(context, status),
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
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Choisissez une action pour la réservation #$reservationId',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildActionButton(
              context: context,
              label: 'Confirmer la réservation',
              icon: Icons.check_circle,
              color: Colors.green,
              status: 'Confirmée',
            ),
            _buildActionButton(
              context: context,
              label: 'Annuler la réservation',
              icon: Icons.cancel,
              color: Colors.red,
              status: 'Annulée',
            ),
          ],
        ),
      ),
    );
  }
}
