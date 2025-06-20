import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:loge_app/pages/ecrans/etudiant/user_page1.dart';

import '../../../../theme/style.dart';
class PersonnaliserPage extends StatefulWidget {
  @override
  _PersonnaliserPageState createState() => _PersonnaliserPageState();
}

class _PersonnaliserPageState extends State<PersonnaliserPage> {
  bool isDarkMode = false;
  String selectedLanguage = 'Français';
  double fontSize = 16.0;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Personnaliser', style: KTypography.h3(context, color: Colors.white)),
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
            Text('Apparence', style: KTypography.h4(context, color: KColors.primary)),
            SizedBox(height: 10),

            // Mode sombre
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: SwitchListTile(
                title: Text('Mode sombre', style: KTypography.h5(context)),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeColor: KColors.primary,
              ),
            ),

            SizedBox(height: 20),
            Text('Langue', style: KTypography.h4(context, color: KColors.primary)),
            SizedBox(height: 10),

            // Langue
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color:  Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    items: ['Français', 'English', 'Español', 'Deutsch'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: KTypography.h5(context)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text('Taille du texte', style: KTypography.h4(context, color: KColors.primary)),
            SizedBox(height: 10),
            // Taille du texte
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color:  Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exemple de texte',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                    ),
                    Slider(
                      value: fontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 6,
                      activeColor: KColors.tertiary,
                      inactiveColor: KColors.tertiary.withOpacity(0.2),
                      label: fontSize.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          fontSize = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // 🔘 Bouton enregistrer
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => UserPage1());
                },
                icon: Icon(Icons.save),
                label: Text('Enregistrer les préférences'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
