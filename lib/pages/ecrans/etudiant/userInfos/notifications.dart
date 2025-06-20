import 'package:flutter/material.dart';
import '../../../../theme/style.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool enableAll = true;
  bool enableMessages = true;
  bool enableRappels = true;
  bool enableMises = true;
  bool enableSon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text('Notifications', style: KTypography.h3(context,color: Colors.white)),
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
            // Paramètres généraux
            Text(
              'Paramètres généraux',
              style: KTypography.h4(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            _buildSwitchTile(
              'Activer toutes les notifications',
              enableAll,
                  (value) {
                setState(() {
                  enableAll = value;
                  if (!value) {
                    enableMessages = false;
                    enableRappels = false;
                    enableMises = false;
                  }
                });
              },
            ),

            SizedBox(height: 5),
            _buildSwitchTile(
              'Son des notifications',
              enableSon,
                  (value) {
                setState(() {
                  enableSon = value;
                });
              },
            ),

            SizedBox(height: 20),
            // Types de notifications
            Text(
              'Types de notifications',
              style: KTypography.h4(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            _buildSwitchTile(
              'Messages',
              enableMessages,
                  (value) {
                setState(() {
                  enableMessages = value;
                  _updateMasterSwitch();
                });
              },
              enabled: enableAll,
            ),

            SizedBox(height: 5),
            _buildSwitchTile(
              'Rappels',
              enableRappels,
                  (value) {
                setState(() {
                  enableRappels = value;
                  _updateMasterSwitch();
                });
              },
              enabled: enableAll,
            ),

            SizedBox(height: 5),
            _buildSwitchTile(
              'Mises à jour',
              enableMises,
                  (value) {
                setState(() {
                  enableMises = value;
                  _updateMasterSwitch();
                });
              },
              enabled: enableAll,
            ),

            SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  // Logique pour effacer l'historique des notifications
                },
                child: Text(
                  'Effacer l\'historique des notifications',
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

  void _updateMasterSwitch() {
    if (enableMessages && enableRappels && enableMises) {
      setState(() {
        enableAll = true;
      });
    }
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged, {bool enabled = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: enabled ? Colors.white: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: KTypography.h5(context).copyWith(
            color: enabled ? null : Colors.black12,
          ),
        ),
        value: enabled ? value : false,
        onChanged: enabled ? onChanged : null,
        activeColor: KColors.primary,
      ),
    );
  }
}