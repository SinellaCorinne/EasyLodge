import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../composants/reservations.dart';
import '../style.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  String _selectedFilter = 'Toutes';
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gestion des Réservations'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export, color: KColors.primary),
            onPressed: () => _exportReservations(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildStatsCards(),
          Expanded(child: _buildReservationsList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher une réservation...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  items: ['Toutes', 'Confirmée', 'En attente', 'Annulée']
                      .map((filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('156', 'Total', KColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('89', 'Confirmées', Colors.green)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('45', 'En attente', Colors.orange)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('22', 'Annulées', Colors.red)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList() {
    List<Map<String, dynamic>> filteredReservations =
        _getFilteredReservations();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReservations.length,
      itemBuilder: (context, index) {
        final reservation = filteredReservations[index];
        return _buildReservationCard(reservation);
      },
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    Color statusColor = _getStatusColor(reservation['statut']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: KColors.primary.withOpacity(0.1),
                  child: Icon(reservation['avatar'], color: KColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['etudiant'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        reservation['id'],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reservation['statut'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reservation['logement'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Propriétaire: ${reservation['proprietaire']}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
           Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${reservation['montant']} FCFA/mois',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: KColors.primary,
                  ),
                ),
                Text(
                  'Du ${reservation['dateDebut']} au ${reservation['dateFin']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                  IconButton(
                    icon: const Icon(Iconsax.eye),
                    onPressed: () => _viewReservationDetails(reservation),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.more),
                    onPressed: () => _showReservationOptions(reservation),
                  ),
                ],

            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmée':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      case 'Annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredReservations() {
    List<Map<String, dynamic>> filtered = reservations;

    if (_selectedFilter != 'Toutes') {
      filtered = filtered
          .where((reservation) => reservation['statut'] == _selectedFilter)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      String searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((reservation) {
        return reservation['etudiant'].toLowerCase().contains(searchTerm) ||
            reservation['logement'].toLowerCase().contains(searchTerm) ||
            reservation['id'].toLowerCase().contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  void _exportReservations() {
    print('Exporter les réservations');
  }

  void _approveReservation(Map<String, dynamic> reservation) {
    print('Approuver la réservation: ${reservation['id']}');
  }

  void _rejectReservation(Map<String, dynamic> reservation) {
    print('Refuser la réservation: ${reservation['id']}');
  }

  void _viewReservationDetails(Map<String, dynamic> reservation) {
    print('Voir les détails: ${reservation['id']}');
  }

  void _showReservationOptions(Map<String, dynamic> reservation) {
    print('Options pour: ${reservation['id']}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
