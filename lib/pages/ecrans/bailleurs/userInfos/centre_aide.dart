import 'package:flutter/material.dart';
import '../../../../theme/style.dart';


class PagesAidePage1 extends StatefulWidget {
  @override
  _PagesAidePage1State createState() => _PagesAidePage1State();
}

class _PagesAidePage1State extends State<PagesAidePage1> {
  // Liste des questions fréquentes
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'Comment modifier mon profil ?',
      'response':
      'Pour modifier votre profil, accédez à la page "Compte" via le menu principal, puis appuyez sur votre nom ou photo de profil. Vous pourrez y modifier vos informations personnelles.',
      'isExpanded': false,
    },
    {
      'question': 'Comment changer mon mot de passe ?',
      'response':
      'Pour changer votre mot de passe, allez dans "Paramètres" > "Confidentialité", puis sélectionnez "Mot de passe". Vous devrez saisir votre ancien mot de passe avant d\'en définir un nouveau.',
      'isExpanded': false,
    },
    {
      'question': 'Comment désactiver les notifications ?',
      'response':
      'Pour désactiver les notifications, accédez à "Paramètres" > "Notifications" et désactivez l\'option "Activer toutes les notifications", ou désactivez uniquement les types de notifications spécifiques que vous ne souhaitez pas recevoir.',
      'isExpanded': false,
    },
    {
      'question': 'Comment supprimer mon compte ?',
      'response':
      'Pour supprimer votre compte, allez dans "Paramètres" > "Confidentialité" > "Supprimer mes données". Attention, cette action est irréversible et toutes vos données seront définitivement supprimées.',
      'isExpanded': false,
    },
    {
      'question': 'Comment contacter le support technique ?',
      'response':
      'Vous pouvez contacter notre équipe de support technique en envoyant un email à support@example.com ou en utilisant le formulaire de contact disponible dans cette section.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Pages d\'aide',
            style: KTypography.h3(context, color: Colors.white)),
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
            // Bannière d'aide
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Besoin d\'aide ?',
                    style: KTypography.h4(context, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Consultez nos guides ou contactez notre support.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showContactForm(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: KColors.primary,
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text('Contacter le support'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Questions fréquentes',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            // Liste des FAQ
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  faqItems[index]['isExpanded'] = !isExpanded;
                });
              },
              children:
              faqItems.map<ExpansionPanel>((Map<String, dynamic> item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item['question'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: KColors.primary,
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item['response'],
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  isExpanded: item['isExpanded'],
                );
              }).toList(),
            ),

            SizedBox(height: 20),
            Text(
              'Guides et tutoriels',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            // Guides
            _buildGuideTile(
              'Guide de démarrage',
              'Apprenez les bases pour bien démarrer',
              Icons.play_circle_outline,
                  () {
                // Navigation vers le guide de démarrage
              },
            ),

            SizedBox(height: 8),
            _buildGuideTile(
              'Fonctionnalités avancées',
              'Découvrez toutes les fonctionnalités avancées',
              Icons.star_outline,
                  () {
                // Navigation vers les fonctionnalités avancées
              },
            ),

            SizedBox(height: 8),
            _buildGuideTile(
              'Résolution des problèmes',
              'Solutions aux problèmes courants',
              Icons.build_outlined,
                  () {
                // Navigation vers la résolution des problèmes
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: KColors.primary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: KColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showContactForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contacter le support'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Sujet',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primary,
              ),
              child: Text('Envoyer'),
              onPressed: () {
                // Logique d'envoi du message
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message envoyé avec succès !'),
                    backgroundColor: KColors.primary,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
