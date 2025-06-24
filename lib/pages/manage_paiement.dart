import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../style.dart';

class PaiementsPage extends StatefulWidget {
  const PaiementsPage({super.key});

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> paiements = [
    {
      'id': 'PAY001',
      'etudiant': 'Marie Kouakou',
      'logement': 'Appartement 2 pièces - Cocody',
      'montant': 45000,
      'date': '2024-06-22 14:30',
      'methode': 'Mobile Money',
      'statut': 'Validé',
      'reference': 'MM240622001',
      'type': 'Loyer',
    },
    {
      'id': 'PAY002',
      'etudiant': 'Jean Diabaté',
      'logement': 'Studio - Marcory',
      'montant': 25000,
      'date': '2024-06-21 10:15',
      'methode': 'Virement',
      'statut': 'En attente',
      'reference': 'VIR240621002',
      'type': 'Caution',
    },
    {
      'id': 'PAY003',
      'etudiant': 'Fatou Traoré',
      'logement': 'Chambre partagée - Adjamé',
      'montant': 15000,
      'date': '2024-06-20 16:45',
      'methode': 'Carte bancaire',
      'statut': 'Échoué',
      'reference': 'CB240620003',
      'type': 'Loyer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gestion des Paiements'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export, color: KColors.primary),
            onPressed: () => _exportPaiements(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildPaymentStatsCards(),
          Expanded(child: _buildPaiementsList()),
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
              hintText: 'Rechercher un paiement...',
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
                  items: ['Tous', 'Validé', 'En attente', 'Échoué']
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

  Widget _buildPaymentStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('2.5M', 'Total', KColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('2.1M', 'Validés', Colors.green)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('250K', 'En attente', Colors.orange)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('150K', 'Échoués', Colors.red)),
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
              fontSize: 16,
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

  Widget _buildPaiementsList() {
    List<Map<String, dynamic>> filteredPaiements = _getFilteredPaiements();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPaiements.length,
      itemBuilder: (context, index) {
        final paiement = filteredPaiements[index];
        return _buildPaiementCard(paiement);
      },
    );
  }

  Widget _buildPaiementCard(Map<String, dynamic> paiement) {
    Color statusColor = _getPaymentStatusColor(paiement['statut']);
    IconData methodIcon = _getPaymentMethodIcon(paiement['methode']);

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: KColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(methodIcon, color: KColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paiement['etudiant'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        paiement['id'],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${paiement['montant']} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: KColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        paiement['statut'],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              paiement['logement'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.calendar, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  paiement['date'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    paiement['type'],
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Réf: ${paiement['reference']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                Row(
                  children: [
                    if (paiement['statut'] == 'En attente') ...[
                      TextButton(
                        onPressed: () => _rejectPayment(paiement),
                        child: const Text('Refuser', style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _approvePayment(paiement),
                        child: const Text('Valider'),
                      ),
                    ] else ...[
                      IconButton(
                        icon: const Icon(Iconsax.receipt),
                        onPressed: () => _viewPaymentReceipt(paiement),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.more),
                        onPressed: () => _showPaymentOptions(paiement),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'Validé':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      case 'Échoué':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'Mobile Money':
        return Iconsax.mobile;
      case 'Virement':
        return Iconsax.bank;
      case 'Carte bancaire':
        return Iconsax.card;
      default:
        return Iconsax.wallet;
    }
  }

  List<Map<String, dynamic>> _getFilteredPaiements() {
    List<Map<String, dynamic>> filtered = paiements;

    if (_selectedFilter != 'Tous') {
      filtered = filtered.where((paiement) => paiement['statut'] == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      String searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((paiement) {
        return paiement['etudiant'].toLowerCase().contains(searchTerm) ||
            paiement['reference'].toLowerCase().contains(searchTerm) ||
            paiement['id'].toLowerCase().contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  void _exportPaiements() {
    print('Exporter les paiements');
  }

  void _approvePayment(Map<String, dynamic> paiement) {
    print('Valider le paiement: ${paiement['id']}');
  }

  void _rejectPayment(Map<String, dynamic> paiement) {
    print('Refuser le paiement: ${paiement['id']}');
  }

  void _viewPaymentReceipt(Map<String, dynamic> paiement) {
    print('Voir le reçu: ${paiement['id']}');
  }

  void _showPaymentOptions(Map<String, dynamic> paiement) {
    print('Options pour: ${paiement['id']}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
