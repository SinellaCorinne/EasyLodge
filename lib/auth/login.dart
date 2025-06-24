import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/register.dart';
import '../composants/api_url.dart';
import '../pages/dashboard.dart';
import '../style.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();
  final box = GetStorage();

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? errorMessage;
  String? successMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez saisir votre email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format d\'email invalide';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez saisir votre mot de passe';
    if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
    return null;
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    try {
      final response = await dio.post(
        '${ApiBaseUrl.baseUrl}/login',
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data;

        if (data['user']['role'] == 'admin') {
          await box.write('admin_token', data['token']);
          await box.write('admin_user', data['user']);

          setState(() => successMessage = "Connexion réussie !");
          await Future.delayed(Duration(seconds: 1));
          Get.offAll(() => AdminDashboardPage());
        } else {
          setState(() => errorMessage = "Accès refusé. Vous n'êtes pas un administrateur.");
        }
      } else {
        setState(() => errorMessage = "Identifiants incorrects.");
      }
    } on DioException catch (e) {
      String message = "Erreur de connexion.";
      if (e.response?.statusCode == 401) message = "Email ou mot de passe incorrect.";
      else if (e.response?.statusCode == 422) message = "Données invalides.";
      else if (e.response?.statusCode == 500) message = "Erreur serveur.";
      setState(() => errorMessage = message);
    } catch (e) {
      setState(() => errorMessage = "Une erreur inattendue s'est produite.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _forgotPassword() {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mot de passe oublié'),
        content: TextFormField(
          controller: resetEmailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Lien de réinitialisation envoyé.'),
                backgroundColor: Colors.green,
              ));
              // Intégration future de l'API ici
            },
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 450 : double.infinity),
                  child: Card(
                    elevation: isDesktop ? 8 : 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset("assets/images/Tiny house-bro.png", height: 100),
                            SizedBox(height: 16),
                            Text("EasyLodge", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: KColors.primary)),
                            Text("Administration", style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 32),
                            TextFormField(
                              controller: emailController,
                              validator: _validateEmail,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Mot de passe",
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  ),
                                  Text("Se souvenir de moi"),
                                ]),
                                TextButton(
                                  onPressed: _forgotPassword,
                                  child: Text("Mot de passe oublié ?", style: TextStyle(color: KColors.primary)),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: KColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text("Se connecter",style: KTypography.h5(context,color: Colors.white),),
                              ),
                            ),
                            if (errorMessage != null) ...[
                              SizedBox(height: 16),
                              Text(errorMessage!, style: TextStyle(color: Colors.red)),
                            ],
                            if (successMessage != null) ...[
                              SizedBox(height: 16),
                              Text(successMessage!, style: TextStyle(color: Colors.green)),
                            ],
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Pas encore de compte ? "),
                                TextButton(
                                  onPressed: () => Get.to(() => AdminDashboardPage()),//() => Get.to(() => RegisterPage()),
                                  child: Text("S'inscrire", style: TextStyle(color: KColors.primary)),
                                ),
                              ],
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
}
