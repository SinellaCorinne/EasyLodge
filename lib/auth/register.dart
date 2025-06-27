import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import '../composants/api_url.dart';
import '../pages/dashboard.dart';
import '../style.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dio.Dio _dio = dio.Dio();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String? errorMessage;
  String? successMessage;
  File? studentCardFile;
  String role = "admin";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _configureDio();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  void _configureDio() {
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);
  }

  @override
  void dispose() {
    _animationController.dispose();
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre nom';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value.trim())) {
      return 'Le nom ne doit contenir que des lettres';
    }
    return null;
  }

  String? _validatePrenom(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre prénom';
    }
    if (value.trim().length < 2) {
      return 'Le prénom doit contenir au moins 2 caractères';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value.trim())) {
      return 'Le prénom ne doit contenir que des lettres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre email';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre numéro de téléphone';
    }
    String cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^(\+229)?[0-9]{8}$').hasMatch(cleanedPhone)) {
      return 'Format: +229 XX XX XX XX ou 8 chiffres';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Doit contenir: majuscule, minuscule et chiffre';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> register() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackbar("Veuillez corriger les erreurs dans le formulaire");
      return;
    }
    if (!_acceptTerms) {
      setState(() {
        errorMessage = "Vous devez accepter les conditions d'utilisation.";
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
    });
    try {
      String cleanedPhone = phoneController.text.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (!cleanedPhone.startsWith('+229')) {
        cleanedPhone = '+229$cleanedPhone';
      }
      Map<String, dynamic> formDataMap = {
        "nom": nomController.text.trim(),
        "prenom": prenomController.text.trim(),
        "tel": cleanedPhone,
        "email": emailController.text.trim().toLowerCase(),
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "role_user": role,
      };
      if (studentCardFile != null) {
        formDataMap["carte_etudiant"] = await dio.MultipartFile.fromFile(
          studentCardFile!.path,
          filename: studentCardFile!.path.split('/').last,
        );
      }
      final formData = dio.FormData.fromMap(formDataMap);
      final response = await _dio.post(
        '${ApiBaseUrl.baseUrl}/register',
        data: formData,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          successMessage = "Inscription réussie ! Redirection vers la connexion...";
        });
        _showSuccessSnackbar("Compte administrateur créé avec succès !");
        await Future.delayed(Duration(seconds: 2));
        Get.offAll(() => Login(), transition: Transition.fadeIn);
      } else {
        setState(() {
          errorMessage = "Erreur lors de l'inscription. Veuillez réessayer.";
        });
      }
    } on dio.DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setState(() {
        errorMessage = "Une erreur inattendue s'est produite.";
      });
      debugPrint('Erreur inscription: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleDioError(dio.DioException e) {
    String message = "Erreur lors de l'inscription.";
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        message = "Problème de connexion. Vérifiez votre réseau.";
        break;
      case dio.DioExceptionType.badResponse:
        if (e.response?.statusCode == 422) {
          final errors = e.response?.data['errors'];
          if (errors != null) {
            message = _parseValidationErrors(errors);
          }
        } else if (e.response?.statusCode == 500) {
          message = "Erreur du serveur. Réessayez plus tard.";
        } else if (e.response?.statusCode == 409) {
          message = "Un compte avec cet email existe déjà.";
        }
        break;
      case dio.DioExceptionType.connectionError:
        message = "Impossible de se connecter au serveur.";
        break;
      default:
        message = "Erreur de réseau. Vérifiez votre connexion.";
    }
    setState(() {
      errorMessage = message;
    });
  }

  String _parseValidationErrors(Map<String, dynamic> errors) {
    if (errors['email'] != null) {
      return "Cette adresse email est déjà utilisée.";
    } else if (errors['tel'] != null) {
      return "Ce numéro de téléphone est déjà utilisé.";
    } else if (errors['password'] != null) {
      return errors['password'][0];
    } else {
      return "Certains champs sont invalides.";
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Erreur",
      message,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      icon: Icon(Icons.error_outline, color: Colors.red[800]),
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      "Succès",
      message,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      icon: Icon(Icons.check_circle_outline, color: Colors.green[800]),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.description_outlined, color: KColors.primary),
              SizedBox(width: 8),
              Text('Conditions d\'utilisation'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTermsSection(
                      "1. Responsabilité d'usage",
                      "En tant qu'administrateur, vous vous engagez à utiliser cette plateforme de manière responsable et éthique."
                  ),
                  _buildTermsSection(
                      "2. Gestion des contenus",
                      "Vous êtes responsable de la modération des contenus et de la gestion des utilisateurs de la plateforme."
                  ),
                  _buildTermsSection(
                      "3. Sanctions",
                      "Toute utilisation abusive de vos privilèges d'administrateur peut entraîner la suspension immédiate de votre compte."
                  ),
                  _buildTermsSection(
                      "4. Confidentialité",
                      "Vous devez respecter strictement la confidentialité des données des utilisateurs et ne pas les divulguer."
                  ),
                  _buildTermsSection(
                      "5. Modifications",
                      "Ces conditions peuvent être modifiées à tout moment. Vous serez notifié des changements importants."
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'J\'ai lu et compris',
                style: TextStyle(color: KColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: KColors.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onFieldSubmitted,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: KColors.primary!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 600 : double.infinity,
                  ),
                  child: Card(
                    elevation: isDesktop ? 8 : 0,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(),
                            SizedBox(height: isDesktop ? 32 : 16),
                            _buildCustomTextField(
                              controller: nomController,
                              label: "Nom",
                              hint: "Dupont",
                              icon: Icons.person_outline,
                              validator: _validateName,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            _buildCustomTextField(
                              controller: prenomController,
                              label: "Prénom",
                              hint: "Jean",
                              icon: Icons.person_outline,
                              validator: _validatePrenom,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            _buildCustomTextField(
                              controller: emailController,
                              label: "Adresse email",
                              hint: "admin@easylodge.com",
                              icon: Icons.email_outlined,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            _buildCustomTextField(
                              controller: phoneController,
                              label: "Numéro de téléphone",
                              hint: "+229 XX XX XX XX",
                              icon: Icons.phone_outlined,
                              validator: _validatePhone,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: isDesktop ? 24 : 16),
                            _buildCustomTextField(
                              controller: passwordController,
                              label: "Mot de passe",
                              hint: "••••••••",
                              icon: Icons.lock_outline,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: isDesktop ? 16 : 8),
                            _buildPasswordRequirements(),
                            SizedBox(height: isDesktop ? 24 : 16),
                            _buildCustomTextField(
                              controller: confirmPasswordController,
                              label: "Confirmer le mot de passe",
                              hint: "••••••••",
                              icon: Icons.lock_outline,
                              validator: _validateConfirmPassword,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => register(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: isDesktop ? 32 : 20),
                            _buildTermsCheckbox(),
                            SizedBox(height: isDesktop ? 32 : 24),
                            _buildRegisterButton(),
                            if (errorMessage != null) _buildErrorMessage(),
                            if (successMessage != null) _buildSuccessMessage(),
                            SizedBox(height: isDesktop ? 32 : 24),
                            _buildLoginLink(),
                            SizedBox(height: isDesktop ? 16 : 8),
                            Center(
                              child: Text(
                                "Création de compte administrateur",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: KColors.secondary.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: KColors.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/Tiny house-bro.png",
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "EasyLodge",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: KColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Créer un compte administrateur",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Exigences du mot de passe :",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            "• Au moins 8 caractères\n• Une majuscule, une minuscule et un chiffre",
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue[700],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: KColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(text: "J'accepte les "),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: _showTermsDialog,
                        child: Text(
                          "conditions d'utilisation",
                          style: TextStyle(
                            color: KColors.primary,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: " et la politique de confidentialité."),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      height: 56,
      child: isLoading
          ? Container(
        decoration: BoxDecoration(
          color: KColors.primary.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
        ),
      )
          : ElevatedButton(
       onPressed: () {
    Get.to(() => AdminDashboardPage(), transition: Transition.fadeIn);
    },  //register,
        style: ElevatedButton.styleFrom(
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: KColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 20),
            SizedBox(width: 8),
            Text(
              "Créer mon compte",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green[700], size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              successMessage!,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Déjà un compte ? ",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => Login(), transition: Transition.fadeIn);
          },
          child: Text(
            "Se connecter",
            style: TextStyle(
              color: KColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
