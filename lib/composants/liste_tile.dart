import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/ecrans/etudiant/details_loge.dart';
import '../theme/style.dart';

class KListTile extends StatelessWidget {
  final String path;
  final String title;
  final String subtitle;

  const KListTile({
    super.key,
    required this.path,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent.withOpacity(0.03),
      child: InkWell(
        onTap:  () => Get.to(const DetailLoge()),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  path,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),

              // Infos
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: KTypography.h4(context, color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              style: KTypography.h5(context, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(4, (index) => const Icon(Icons.star, size: 16, color: Colors.orange)),
                      ),
                    ],
                  ),
                ),
              ),

              // Icône action

            ],
          ),
        ),
      ),
    );
  }
}
