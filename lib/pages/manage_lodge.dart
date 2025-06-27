import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../composants/logements.dart';
import '../style.dart';

class LogementsPage extends StatefulWidget {
  const LogementsPage({super.key});

  @override
  State<LogementsPage> createState() => _LogementsPageState();
}

class _LogementsPageState extends State<LogementsPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gestion des Logements'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle, color: KColors.primary),
            onPressed: () => _showAddLogementDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildStatsCards(),
          Expanded(child: _buildLogementsList()),
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
              hintText: 'Rechercher un logement...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
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
                  items: ['Tous', 'Disponible', 'Réservé', 'En attente']
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
          Expanded(
            child: _buildStatCard('250', 'Total', KColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('180', 'Disponibles', Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('50', 'Réservés', Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('20', 'En attente', Colors.red),
          ),
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

  Widget _buildLogementsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logements.length,
      itemBuilder: (context, index) {
        final logement = logements[index];
        return _buildLogementCard(logement);
      },
    );
  }

  Widget _buildLogementCard(Map<String, dynamic> logement) {
    Color statusColor = _getStatusColor(logement['statut']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    logement['titre'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    logement['statut'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.location, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  logement['adresse'],
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Iconsax.user, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Bailleur: ${logement['bailleur']}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${logement['prix']} FCFA/mois',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: KColors.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.eye, color: KColors.primary),
                      onPressed: () => _viewLogement(logement),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.edit, color: Colors.orange),
                      onPressed: () => _editLogement(logement),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      onPressed: () => _deleteLogement(logement),
                    ),
                  ],
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
      case 'Disponible':
        return Colors.green;
      case 'Réservé':
        return Colors.orange;
      case 'En attente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddLogementDialog() {
    // Logique d'ajout de logement
  }

  void _viewLogement(Map<String, dynamic> logement) {
    // Afficher les détails du logement
  }

  void _editLogement(Map<String, dynamic> logement) {
    // Modifier le logement
  }

  void _deleteLogement(Map<String, dynamic> logement) {
    // Supprimer le logement
  }
}