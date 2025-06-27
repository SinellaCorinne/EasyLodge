import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../composants/paiements.dart';
import '../style.dart';

class PaiementsPage extends StatefulWidget {
  const PaiementsPage({super.key});

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
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
          SizedBox(height: isDesktop ? 20 : 12),
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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('2.5M', 'Total', KColors.primary)),
          SizedBox(width: isDesktop ? 24 : 12),
          Expanded(child: _buildStatCard('2.1M', 'Validés', Colors.green)),
          SizedBox(width: isDesktop ? 24 : 12),
          Expanded(child: _buildStatCard('250K', 'En attente', Colors.orange)),
          SizedBox(width: isDesktop ? 24 : 12),
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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    Color statusColor = _getPaymentStatusColor(paiement['statut']);
    IconData methodIcon = _getPaymentMethodIcon(paiement['methode']);

    return Card(
      margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
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
                SizedBox(width: isDesktop ? 24 : 12),
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
            SizedBox(height: isDesktop ? 20 : 12),
            Text(
              paiement['logement'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: isDesktop ? 16 : 8),
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
            SizedBox(height: isDesktop ? 16 : 8),
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
                    IconButton(
                      icon: const Icon(Iconsax.receipt),
                      onPressed: () => _viewPaymentReceipt(paiement),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.more),
                      onPressed: () => _showPaymentOptions(paiement),
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
