import 'package:flutter/material.dart';

import '../../../../theme/style.dart';


class TermesConditionsPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Termes et Conditions', style: KTypography.h3(context,color:Colors.white)),
        backgroundColor: KColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dernière mise à jour: 12 mars 2025',
                    style: TextStyle(
                      color: KColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            _buildSection(
              context,
              'Introduction',
              'Bienvenue dans notre application. En utilisant notre service, vous acceptez de respecter les termes et conditions décrits dans ce document. Veuillez les lire attentivement avant d\'utiliser l\'application.',
            ),

            _buildSection(
              context,
              'Définitions',
              '- "Application" désigne notre plateforme mobile et web.\n'
                  '- "Utilisateur", "Vous" désigne toute personne qui accède ou utilise l\'application.\n'
                  '- "Contenu" désigne toutes les informations et données accessibles ou générées via l\'application.',
            ),

            _buildSection(
              context,
              'Conditions d\'utilisation',
              'En utilisant notre application, vous vous engagez à :\n\n'
                  '1. Fournir des informations exactes lors de l\'inscription\n'
                  '2. Maintenir la confidentialité de vos informations de connexion\n'
                  '3. Ne pas utiliser l\'application à des fins illégales ou non autorisées\n'
                  '4. Ne pas tenter de nuire au fonctionnement de l\'application',
            ),

            _buildSection(
              context,
              'Propriété intellectuelle',
              'Tous les droits de propriété intellectuelle relatifs à l\'application et son contenu appartiennent à notre entreprise. Vous n\'êtes pas autorisé à reproduire, distribuer, modifier ou créer des œuvres dérivées sans notre autorisation explicite.',
            ),

            _buildSection(
              context,
              'Limitation de responsabilité',
              'Dans toute la mesure permise par la loi applicable, nous ne sommes pas responsables des dommages directs, indirects, accessoires, consécutifs ou punitifs résultant de votre utilisation ou de votre incapacité à utiliser l\'application.',
            ),

            _buildSection(
              context,
              'Modifications des conditions',
              'Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications entreront en vigueur dès leur publication dans l\'application. Votre utilisation continue de l\'application après ces modifications constitue votre acceptation des nouvelles conditions.',
            ),

            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Logique pour télécharger la version PDF
                },
                child: Text(
                  'Télécharger en PDF',
                  style: TextStyle(
                    color: KColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: KTypography.h5(context, color: KColors.primary),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}