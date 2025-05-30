import 'package:flutter/material.dart';
import '../../../theme/style.dart';

class FilterBar extends StatelessWidget {
  final List<String> categories;
  final List<String> zones;
  final void Function(String?)? onZoneChanged;

  const FilterBar({
    Key? key,
    required this.categories,
    required this.zones,
    this.onZoneChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barre de recherche
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: KTypography.h5(context, color: KColors.primary),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Rechercher un logement...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Filtres horizontaux (catégories)
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return Chip(
                label: Text(categories[index]),
                backgroundColor: KColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
