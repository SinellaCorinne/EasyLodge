import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loge_admin/pages/privacy.dart';
import 'package:loge_admin/pages/session.dart';
import 'package:loge_admin/pages/support.dart';
import 'package:loge_admin/pages/terms_page.dart';
import '../auth/password_f.dart';
import '../style.dart';
import 'activity_log.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkMode = false;
  bool _autoBackup = true;
  String _selectedLanguage = 'Français';
  String _selectedCurrency = 'FCFA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Notifications push',
                'Recevoir les notifications sur l\'appareil',
                _notificationsEnabled,
                    (value) => setState(() => _notificationsEnabled = value),
                Iconsax.notification,
              ),
              _buildSwitchTile(
                'Notifications email',
                'Recevoir les notifications par email',
                _emailNotifications,
                    (value) => setState(() => _emailNotifications = value),
                Iconsax.sms,
              ),
              _buildSwitchTile(
                'Notifications SMS',
                'Recevoir les notifications par SMS',
                _smsNotifications,
                    (value) => setState(() => _smsNotifications = value),
                Iconsax.message,
              ),
            ],
          ),
          _buildSection(
            'Apparence',
            [
              _buildSwitchTile(
                'Mode sombre',
                'Utiliser le thème sombre',
                _darkMode,
                    (value) => setState(() => _darkMode = value),
                Iconsax.moon,
              ),
              _buildDropdownTile(
                'Langue',
                'Choisir la langue de l\'interface',
                _selectedLanguage,
                ['Français', 'English', 'العربية'],
                    (value) => setState(() => _selectedLanguage = value!),
                Iconsax.language_square,
              ),
            ],
          ),
          _buildSection(
            'Système',
            [
              _buildSwitchTile(
                'Sauvegarde automatique',
                'Sauvegarder automatiquement les données',
                _autoBackup,
                    (value) => setState(() => _autoBackup = value),
                Iconsax.refresh,
              ),
              _buildDropdownTile(
                'Devise',
                'Devise par défaut',
                _selectedCurrency,
                ['FCFA', 'EUR', 'USD'],
                    (value) => setState(() => _selectedCurrency = value!),
                Iconsax.money,
              ),
              _buildActionTile(
                'Vider le cache',
                'Supprimer les fichiers temporaires',
                    () => _clearCache(),
                Iconsax.trash,
              ),
              _buildActionTile(
                'Exporter les données',
                'Télécharger une copie de vos données',
                    () => _exportData(),
                Iconsax.export,
              ),
            ],
          ),
          _buildSection(
            'Sécurité',
            [
              _buildActionTile(
                'Changer le mot de passe',
                'Modifier votre mot de passe administrateur',
                    () => _changePassword(),
                Iconsax.lock,
              ),
              _buildActionTile(
                'Sessions actives',
                'Gérer les sessions de connexion',
                    () => _manageSessions(),
                Iconsax.security_user,
              ),
              _buildActionTile(
                'Journal d\'activité',
                'Voir l\'historique des actions',
                    () => _viewActivityLog(),
                Iconsax.document_text,
              ),
            ],
          ),
          _buildSection(
            'À propos',
            [
              _buildInfoTile(
                'Version',
                'EasyLodge Admin v1.0.0',
                Iconsax.info_circle,
              ),
              _buildActionTile(
                'Conditions d\'utilisation',
                'Lire les conditions d\'utilisation',
                    () => _viewTerms(),
                Iconsax.document,
              ),
              _buildActionTile(
                'Politique de confidentialité',
                'Consulter notre politique de confidentialité',
                    () => _viewPrivacyPolicy(),
                Iconsax.shield_security,
              ),
              _buildActionTile(
                'Support technique',
                'Contacter l\'équipe technique',
                    () => _contactSupport(),
                Iconsax.call,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Méthode pour construire une section
  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // Méthode pour construire un tile avec switch
  Widget _buildSwitchTile(
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      IconData icon,
      ) {
    return ListTile(
      leading: Icon(icon, color: KColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor:  KColors.primary,
      ),
    );
  }

  // Méthode pour construire un tile avec dropdown
  Widget _buildDropdownTile(
      String title,
      String subtitle,
      String value,
      List<String> items,
      Function(String?) onChanged,
      IconData icon,
      ) {
    return ListTile(
      leading: Icon(icon, color:  KColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  // Méthode pour construire un tile d'action
  Widget _buildActionTile(
      String title,
      String subtitle,
      VoidCallback onTap,
      IconData icon,
      ) {
    return ListTile(
      leading: Icon(icon, color:  KColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Méthode pour construire un tile d'information
  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color:  KColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(
        value,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }

  // ==================== MÉTHODES D'ACTION ====================

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider le cache'),
        content: const Text('Êtes-vous sûr de vouloir vider le cache ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Cache vidé avec succès');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Vider', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    _showSuccessSnackBar('Export des données en cours...');
    // Logique d'export des données
  }

  void _changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  }

  void _manageSessions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionsPage(),
      ),
    );
  }

  void _viewActivityLog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityLogPage(),
      ),
    );
  }

  void _viewTerms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsPage(),
      ),
    );
  }

  void _viewPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyPage(),
      ),
    );
  }

  void _contactSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SupportPage(),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}





