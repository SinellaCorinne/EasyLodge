import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../auth/login.dart';
import '../style.dart';
import 'manage_lodge.dart';
import 'manage_paiement.dart';
import 'manage_reservation.dart';
import 'manage_user.dart';
import 'messagerie.dart';
import 'paramètres.dart';
import 'profil.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, dynamic> dashboardStats = {
    'logements_disponibles': 250,
    'logements_reserves': 120,
    'etudiants': 1200,
    'bailleurs': 80,
    'total_logements': 370,
    'paiements_mois': 230,
    'revenus_mois': 45000,
    'nouveaux_utilisateurs_semaine': 15,
  };

  final List<Map<String, dynamic>> recentNotifications = [
    {
      'icon': Iconsax.wallet_check,
      'title': 'Paiement effectué',
      'description': 'Logement #123 - 25,000 FCFA',
      'time': '5 min',
      'isNew': true,
    },
    {
      'icon': Iconsax.calendar,
      'title': 'Nouvelle réservation',
      'description': 'Logement #456 par Marie Kouakou',
      'time': '15 min',
      'isNew': true,
    },
    {
      'icon': Iconsax.message,
      'title': 'Messages non lus',
      'description': '3 nouveaux messages',
      'time': '1h',
      'isNew': false,
    },
    {
      'icon': Iconsax.user,
      'title': 'Nouvel utilisateur',
      'description': 'Jean Diabaté s\'est inscrit',
      'time': '2h',
      'isNew': false,
    },
    {
      'icon': Iconsax.home,
      'title': 'Logement en attente',
      'description': 'Validation requise pour logement #789',
      'time': '3h',
      'isNew': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Tableau de Bord', style: KTypography.h2(context)),
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black12,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Iconsax.notification, color: KColors.primary),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: const Text(
                  '5',
                  style: TextStyle(color: Colors.white, fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: KColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Iconsax.user, size: 30, color: KColors.primary),
                ),
                const SizedBox(height: 10),
                const Text('Admin', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('admin@easylodge.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Iconsax.home, color: KColors.primary),
            title: Text('Accueil', style: KTypography.h5(context)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Iconsax.home_hashtag, color: KColors.primary),
            title: Text('Logements', style: KTypography.h5(context)),
            onTap: () => Get.to(LogementsPage()),
          ),
          ListTile(
            leading: Icon(Iconsax.user, color: KColors.primary),
            title: Text('Utilisateurs', style: KTypography.h5(context)),
            onTap: () => Get.to(UtilisateursPage()),
          ),
          ListTile(
            leading: Icon(Iconsax.message, color: KColors.primary),
            title: Text('Messages', style: KTypography.h5(context)),
            onTap: () => Get.to(MessagesPage()),
          ),
          ListTile(
            leading: Icon(Iconsax.menu_board, color: KColors.primary),
            title: Text('Réservations', style: KTypography.h5(context)),
            onTap: () => Get.to(ReservationsPage()),
          ),
          ListTile(
            leading: Icon(Iconsax.money, color: KColors.primary),
            title: Text('Paiements', style: KTypography.h5(context)),
            onTap: () => Get.to(PaiementsPage()),
          ),
          ListTile(
            leading: Icon(Iconsax.setting, color: KColors.primary),
            title: Text('Paramètres', style: KTypography.h5(context)),
            onTap: () => Get.to(ParametresPage()),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Iconsax.profile_circle, color: KColors.primary),
            title: Text('Profil', style: KTypography.h5(context)),
            onTap: () => Get.to(AdminProfilePage()),
          ),
          ListTile(
            leading: Icon(Iconsax.logout, color: Colors.red),
            title: Text('Déconnexion', style: KTypography.h5(context, color: Colors.red)),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: isDesktop ? 32 : 24),
          _buildQuickStats(),
          SizedBox(height: isDesktop ? 32 : 24),
          _buildChartsSection(),
          SizedBox(height: isDesktop ? 32 : 24),
          _buildDetailedStats(),
          SizedBox(height: isDesktop ? 32 : 24),
          _buildNotificationsSection(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher dans le dashboard...',
          prefixIcon: const Icon(Iconsax.search_normal, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vue d\'ensemble',
          style: KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                '${dashboardStats['logements_disponibles']}',
                'Logements disponibles',
                KColors.primary,
                Iconsax.home,
              ),
            ),
            SizedBox(width: isDesktop ? 24 : 12),
            Expanded(
              child: _buildSummaryCard(
                '${dashboardStats['logements_reserves']}',
                'Logements réservés',
                KColors.secondary,
                Iconsax.calendar,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 24 : 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                '${(dashboardStats['revenus_mois'] / 1000).toStringAsFixed(0)}K FCFA',
                'Revenus ce mois',
                Colors.green,
                Iconsax.wallet_check,
              ),
            ),
            SizedBox(width: isDesktop ? 24 : 12),
            Expanded(
              child: _buildSummaryCard(
                '+${dashboardStats['nouveaux_utilisateurs_semaine']}',
                'Nouveaux cette semaine',
                Colors.orange,
                Iconsax.user_add,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.arrow_up_3, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques détaillées',
          style: KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        Row(
          children: [
            Expanded(child: _buildChartBox('Utilisateurs actifs')),
            SizedBox(width: isDesktop ? 24 : 12),
            Expanded(child: _buildChartBox('Réservations récentes')),
          ],
        ),
      ],
    );
  }

  Widget _buildChartBox(String title) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KTypography.h5(context).copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                'Graphique ',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    final stats = [
      {'icon': Iconsax.user, 'label': 'Étudiants', 'value': '${dashboardStats['etudiants']}'},
      {'icon': Iconsax.building_3, 'label': 'Bailleurs', 'value': '${dashboardStats['bailleurs']}'},
      {'icon': Iconsax.home, 'label': 'Logements', 'value': '${dashboardStats['total_logements']}'},
      {'icon': Iconsax.wallet_check, 'label': 'Paiements', 'value': '${dashboardStats['paiements_mois']}'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques globales',
          style: KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        Wrap(
          spacing: isDesktop ? 24 : 12,
          runSpacing: isDesktop ? 24 : 12,
          children: stats.map((stat) => _buildStatCard(
            stat['icon'] as IconData,
            stat['label'] as String,
            stat['value'] as String,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Container(
      width: isDesktop ? (size.width - 96) / 4 : (size.width - 56) / 2,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: KColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications récentes',
              style: KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Tout', style: TextStyle(color: KColors.primary)),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        ...recentNotifications.take(5).map((notification) => Padding(
          padding: EdgeInsets.only(bottom: isDesktop ? 16 : 8),
          child: _buildNotificationItem(
            notification['icon'] as IconData,
            notification['title'] as String,
            notification['description'] as String,
            notification['time'] as String,
            notification['isNew'] as bool,
          ),
        )),
      ],
    );
  }

  Widget _buildNotificationItem(IconData icon, String title, String description, String time, bool isNew) {
    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: KColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: KColors.primary, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(title, style: KTypography.h6(context).copyWith(fontWeight: FontWeight.w600)),
            ),
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Nouveau',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              'Il y a $time',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAll(() => Login());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
