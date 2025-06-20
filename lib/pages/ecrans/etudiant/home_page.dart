import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loge_app/composants/filtres.dart';
import 'package:loge_app/pages/ecrans/etudiant/recherche_avance.dart';
import '../../../composants/liste_tile.dart';
import '../../../composants/logement_card.dart';
import '../../../theme/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> logementsRecents = [
    {
      "titre": "Studio moderne",
      "lieu": "Calavi",
      "prix": "15 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
    {
      "titre": "Chambre simple",
      "lieu": "Abomey",
      "prix": "10 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
    {
      "titre": "Appartement T2",
      "lieu": "Cotonou",
      "prix": "25 000 FCFA",
      "image": "assets/images/logement.jpeg"
    },
  ];

  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0), // ✅ Padding global
        child: ListView(
          children: [
            /// 🏠 Titre principal
            Text(
              "Trouvez votre logement en quelques clics",
              style: KTypography.h3(context, color: KColors.primary)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// 🔍 Barre de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un logement...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => Get.to(() => RecherchePage()),
                ),
              ),
            ),

            /// Filtres uniquement si recherche
            if (_isSearching) const Filtres(),

            const SizedBox(height: 10),

            /// 🆕 Logements récents uniquement si pas de recherche
            if (!_isSearching) _buildSectionTitle(context, "🏠 Logements récents"),
            if (!_isSearching) const SizedBox(height: 12),
            if (!_isSearching)
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: logementsRecents.length,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final logement = logementsRecents[index];
                    return LogementCard(logement: logement);
                  },
                ),
              ),

            const SizedBox(height: 7),
            /// 🌟 Logements mieux notés
            _buildSectionTitle(context, "⭐ Logements mieux notés"),
            const SizedBox(height: 12),
            ...List.generate(
              10,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: KListTile(
                  path: "assets/images/logement.jpeg",
                  title: "Studio moderne",
                  subtitle: "10 000 FCFA",
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 💡 Conseils logement
            _buildSectionTitle(context, "💡 Conseils logement", isSmall: true),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
                title: Text("Vérifiez bien l'état du logement avant de réserver."),
                subtitle: Text("Un état des lieux est fortement recommandé."),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {bool isSmall = false}) {
    return Text(
      title,
      style: isSmall
          ? KTypography.h6(context)
          : KTypography.h4(context, color: KColors.primary),
    );
  }
}



//Center(
//                 child: ElevatedButton.icon(
//                   onPressed: () => Get.to(RecherchePage()),
//                   icon: const Icon(Icons.search),
//                   label: const Text("Recherche avancée"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: KColors.primary,
//                     elevation: 4,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//
//
//               ),
//Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF575992),Color(0xFF575992)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Bienvenue, Etudiant 👋",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       const Text(
//                         "Trouver votre logement étudiant en quelques clics.",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//               ),
