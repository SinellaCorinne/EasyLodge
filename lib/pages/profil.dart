import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../style.dart';

// ==================== PAGE PROFIL ADMIN ====================
class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  // Données simulées de l'admin - à remplacer par vos vraies données
  Map<String, dynamic> adminData = {
    'nom': 'KOUASSI',
    'prenom': 'Jean-Baptiste',
    'email': 'admin@easylodge.com',
    'phone': '+225 07 XX XX XX XX',
    'adresse': 'Cocody, Abidjan',
    'bio':
        'Administrateur système EasyLodge avec 5 ans d\'expérience dans la gestion de plateformes de logement étudiant.',
    'dateCreation': '15 Mars 2023',
    'dernierConnexion': 'Aujourd\'hui à 14:30',
    'role': 'Super Administrateur',
    'statut': 'Actif',
    'photoUrl': null, // URL de la photo de profil
  };

  // Statistiques de l'admin
  final Map<String, dynamic> adminStats = {
    'logementsGeres': 370,
    'utilisateursActifs': 1200,
    'revenus': '2.5M FCFA',
    'tacheCompletes': 89,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nomController.text = adminData['nom'] ?? '';
    _prenomController.text = adminData['prenom'] ?? '';
    _emailController.text = adminData['email'] ?? '';
    _phoneController.text = adminData['phone'] ?? '';
    _adresseController.text = adminData['adresse'] ?? '';
    _bioController.text = adminData['bio'] ?? '';
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _adresseController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Mon Profil', style: KTypography.h2(context)),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (!_isEditing)
          IconButton(
            icon: const Icon(Iconsax.edit, color: KColors.primary),
            onPressed: () => setState(() => _isEditing = true),
          ),
        if (_isEditing) ...[
          TextButton(
            onPressed: _cancelEdit,
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: _saveProfile,
            child:
                const Text('Sauver', style: TextStyle(color: KColors.primary)),
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildProfileForm(),
          const SizedBox(height: 24),
          _buildAccountInfo(),
          const SizedBox(height: 24),
          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: KColors.primary.withOpacity(0.1),
                backgroundImage: adminData['photoUrl'] != null
                    ? NetworkImage(adminData['photoUrl'])
                    : null,
                child: adminData['photoUrl'] == null
                    ? const Icon(Iconsax.user, size: 50, color: KColors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePhoto,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: KColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Iconsax.camera,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${adminData['prenom']} ${adminData['nom']}',
            style:
                KTypography.h2(context).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: KColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              adminData['role'],
              style: TextStyle(
                color: KColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                adminData['statut'],
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = [
      {
        'icon': Iconsax.home,
        'value': '${adminStats['logementsGeres']}',
        'label': 'Logements\ngérés',
        'color': KColors.primary,
      },
      {
        'icon': Iconsax.user,
        'value': '${adminStats['utilisateursActifs']}',
        'label': 'Utilisateurs\nactifs',
        'color': Colors.blue,
      },
      {
        'icon': Iconsax.wallet_check,
        'value': adminStats['revenus'],
        'label': 'Revenus\ntotaux',
        'color': Colors.green,
      },
      {
        'icon': Iconsax.task_square,
        'value': '${adminStats['tacheCompletes']}%',
        'label': 'Tâches\ncomplétées',
        'color': Colors.orange,
      },
    ];

    return Row(
      children: stats
          .map((stat) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
                  child: Column(
                    children: [
                      Icon(
                        stat['icon'] as IconData,
                        color: stat['color'] as Color,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat['value'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: stat['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildProfileForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations personnelles',
              style:
                  KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Nom',
                    _nomController,
                    Iconsax.user,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Prénom',
                    _prenomController,
                    Iconsax.user,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Email',
              _emailController,
              Iconsax.sms,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Téléphone',
              _phoneController,
              Iconsax.call,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Adresse',
              _adresseController,
              Iconsax.location,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Bio',
              _bioController,
              Iconsax.document_text,
              enabled: _isEditing,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, color: enabled ? KColors.primary : Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KColors.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade50,
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (!enabled) return null;
            if (value == null || value.isEmpty) {
              return '$label est requis';
            }
            if (label == 'Email' && !GetUtils.isEmail(value)) {
              return 'Email invalide';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAccountInfo() {
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
          Text(
            'Informations du compte',
            style:
                KTypography.h3(context).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
              'Date de création', adminData['dateCreation'], Iconsax.calendar),
          const SizedBox(height: 12),
          _buildInfoRow('Dernière connexion', adminData['dernierConnexion'],
              Iconsax.clock),
          const SizedBox(height: 12),
          _buildInfoRow('Rôle', adminData['role'], Iconsax.security_user),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: KColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          'Changer le mot de passe',
          'Modifier votre mot de passe de connexion',
          Iconsax.lock,
          () => _changePassword(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Paramètres de sécurité',
          'Gérer l\'authentification et la sécurité',
          Iconsax.shield_security,
          () => _securitySettings(),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Historique des activités',
          'Voir votre historique de connexions',
          Iconsax.document_text,
          () => _viewActivityHistory(),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: KColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: KColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // ==================== MÉTHODES D'ACTION ====================

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Changer la photo de profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption('Caméra', Iconsax.camera, () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                }),
                _buildPhotoOption('Galerie', Iconsax.gallery, () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                }),
                _buildPhotoOption('Supprimer', Iconsax.trash, () {
                  Navigator.pop(context);
                  _removeProfilePhoto();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: KColors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _pickImageFromCamera() {
    _showSuccessSnackBar('Fonctionnalité caméra à implémenter');
  }

  void _pickImageFromGallery() {
    _showSuccessSnackBar('Fonctionnalité galerie à implémenter');
  }

  void _removeProfilePhoto() {
    setState(() {
      adminData['photoUrl'] = null;
    });
    _showSuccessSnackBar('Photo de profil supprimée');
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    _initializeControllers(); // Restaurer les valeurs originales
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation d'un appel API
      await Future.delayed(const Duration(seconds: 2));

      // Sauvegarder les nouvelles données
      adminData['nom'] = _nomController.text;
      adminData['prenom'] = _prenomController.text;
      adminData['email'] = _emailController.text;
      adminData['phone'] = _phoneController.text;
      adminData['adresse'] = _adresseController.text;
      adminData['bio'] = _bioController.text;

      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      _showSuccessSnackBar('Profil mis à jour avec succès');
    }
  }

  void _changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  }

  void _securitySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsPage(),
      ),
    );
  }

  void _viewActivityHistory() {}

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: KColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ==================== PAGES AUXILIAIRES ====================

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Iconsax.lock,
                  size: 64,
                  color: KColors.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Modifier votre mot de passe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pour votre sécurité, veuillez saisir votre mot de passe actuel',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                _buildPasswordField(
                  'Mot de passe actuel',
                  _currentPasswordController,
                  _showCurrentPassword,
                  () => setState(
                      () => _showCurrentPassword = !_showCurrentPassword),
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  'Nouveau mot de passe',
                  _newPasswordController,
                  _showNewPassword,
                  () => setState(() => _showNewPassword = !_showNewPassword),
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  'Confirmer le nouveau mot de passe',
                  _confirmPasswordController,
                  _showConfirmPassword,
                  () => setState(
                      () => _showConfirmPassword = !_showConfirmPassword),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Changer le mot de passe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback onToggle, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Iconsax.lock, color: KColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Iconsax.eye : Iconsax.eye_slash,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KColors.primary),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label est requis';
                }
                if (value.length < 6) {
                  return 'Le mot de passe doit contenir au moins 6 caractères';
                }
                return null;
              },
        ),
      ],
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulation d'un appel API
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mot de passe modifié avec succès'),
          backgroundColor: KColors.primary,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Paramètres de sécurité'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Iconsax.shield_security,
                    size: 64,
                    color: KColors.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Paramètres de sécurité',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Page de gestion des paramètres de sécurité',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
