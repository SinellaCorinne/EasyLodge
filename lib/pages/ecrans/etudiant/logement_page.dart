import 'package:flutter/material.dart';
import '../../../theme/style.dart';

class LogementPage extends StatefulWidget {
  const LogementPage({super.key});

  @override
  State<LogementPage> createState() => _LogementPageState();
}

class _LogementPageState extends State<LogementPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
    "assets/images/logement.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mon Logement",
          style: KTypography.h3(context, color: KColors.primary),
        ),
        foregroundColor: KColors.primary,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        children: [
          /// 🖼️ Carousel d’images
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) => Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _images.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.blueGrey
                                : Colors.blueGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// 📝 Infos du logement
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chambre à Agla",
                      style: KTypography.h3(context, color: KColors.primary)),
                  const SizedBox(height: 8),
                  Text("Loyer : 18 000 FCFA / mois",
                      style: KTypography.h4(context)),
                  const SizedBox(height: 6),
                  Text("Prochaine échéance : 5 juin 2025",
                      style: KTypography.h4(context)),
                  const SizedBox(height: 6),
                  Text(
                    "Statut : Réservé",
                    style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          /// 📱 Actions utilisateur
          ActionTile(
            icon: Icons.phone,
            label: "Contacter le bailleur",
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.payment,
            label: "Payer le loyer",
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.water_drop,
            label: "Payer facture eau (SONEB)",
            onTap: () {},
          ),
          ActionTile(
            icon: Icons.flash_on,
            label: "Payer facture électricité (SBEE)",
            onTap: () {},
          ),
          const SizedBox(height: 32),

          /// ✍️ Zone d’avis
          Text("Laisser un avis", style: KTypography.h5(context)),
          const SizedBox(height: 12),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: KColors.secondary.withOpacity(0.08),
              hintText: "Écrivez votre avis ici...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),

          /// 📤 Bouton d'envoi
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
              ),
              child: const Text(
                "Envoyer l'avis",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shadowColor: Colors.grey.withOpacity(0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: KColors.primary.withOpacity(0.15),
          radius: 22,
          child: Icon(icon, color: KColors.primary, size: 24),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: KColors.primary),
        onTap: onTap,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
