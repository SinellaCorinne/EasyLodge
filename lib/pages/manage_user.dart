
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../style.dart';

class UtilisateursPage extends StatefulWidget {
  const UtilisateursPage({super.key});

  @override
  State<UtilisateursPage> createState() => _UtilisateursPageState();
}

class _UtilisateursPageState extends State<UtilisateursPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> utilisateurs = [
    {
      'id': '001',
      'nom': 'Marie Kouakou',
      'email': 'marie.kouakou@gmail.com',
      'type': 'Bailleur',
      'telephone': '+225 07 12 34 56 78',
      'dateInscription': '2024-06-15',
      'statut': 'Actif',
      'logements': 3,
    },
    {
      'id': '002',
      'nom': 'Jean Diabaté',
      'email': 'jean.diabate@student.com',
      'type': 'Étudiant',
      'telephone': '+225 05 98 76 54 32',
      'dateInscription': '2024-06-10',
      'statut': 'Actif',
      'reservations': 1,
    },
    {
      'id': '003',
      'nom': 'Fatou Traoré',
      'email': 'fatou.traore@gmail.com',
      'type': 'Bailleur',
      'telephone': '+225 01 23 45 67 89',
      'dateInscription': '2024-06-05',
      'statut': 'Suspendu',
      'logements': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.user_add, color: KColors.primary),
            onPressed: () => _showAddUserDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildUserStatsCards(),
          Expanded(child: _buildUsersList()),
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
              hintText: 'Rechercher un utilisateur...',
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
                  items: ['Tous', 'Étudiant', 'Bailleur', 'Actif', 'Suspendu']
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

  Widget _buildUserStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('1280', 'Total', KColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('1200', 'Étudiants', Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('80', 'Bailleurs', Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('15', 'Nouveaux', Colors.orange),
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

  Widget _buildUsersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: utilisateurs.length,
      itemBuilder: (context, index) {
        final user = utilisateurs[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    Color statusColor = user['statut'] == 'Actif' ? Colors.green : Colors.red;
    Color typeColor = user['type'] == 'Étudiant' ? Colors.blue : Colors.purple;

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
                  radius: 25,
                  backgroundColor: typeColor.withOpacity(0.1),
                  child: Icon(
                    user['type'] == 'Étudiant' ? Iconsax.user : Iconsax.building,
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['nom'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user['email'],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['statut'],
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user['type'],
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Iconsax.call, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  user['telephone'],
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.calendar, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Inscrit le ${user['dateInscription']}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user['type'] == 'Bailleur'
                      ? '${user['logements']} logements'
                      : '${user['reservations'] ?? 0} réservations',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: KColors.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.eye, color: KColors.primary),
                      onPressed: () => _viewUser(user),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.edit, color: Colors.orange),
                      onPressed: () => _editUser(user),
                    ),
                    IconButton(
                      icon: Icon(
                        user['statut'] == 'Actif' ? Iconsax.user_remove : Iconsax.user_tick,
                        color: user['statut'] == 'Actif' ? Colors.red : Colors.green,
                      ),
                      onPressed: () => _toggleUserStatus(user),
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

  void _showAddUserDialog() {
    // Logique d'ajout d'utilisateur
  }

  void _viewUser(Map<String, dynamic> user) {
    // Afficher les détails de l'utilisateur
  }

  void _editUser(Map<String, dynamic> user) {
    // Modifier l'utilisateur
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    // Activer/Suspendre l'utilisateur
  }
}
