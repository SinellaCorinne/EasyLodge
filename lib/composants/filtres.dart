import 'package:flutter/material.dart';
import '../../theme/style.dart'; // Mets à jour ce chemin si besoin

class Filtres extends StatefulWidget {
  const Filtres({super.key});

  @override
  State<Filtres> createState() => _FiltresState();
}

class _FiltresState extends State<Filtres> {
  final List<String> categories = [
    "Tous",
    "Studios",
    "Chambres",
    "Appartements",
    "Meublés",
    "Non-meublés",
  ];

  String selectedCategory = "Tous";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: selectedCategory == cat,
              selectedColor: KColors.primary,
              backgroundColor: Colors.grey[200],
              onSelected: (_) {
                setState(() {
                  selectedCategory = cat;
                  // TODO: Notify parent widget or filter the list
                });
              },
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: selectedCategory == cat ? Colors.white : Colors.black87,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}
