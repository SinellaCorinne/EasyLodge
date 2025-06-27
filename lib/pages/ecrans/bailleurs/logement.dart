class Logement {
  final int? id;
  final String? titre;
  final String? description;
  final int? prix;
  final List<String>? images;

  Logement({
    this.id,
    this.titre,
    this.description,
    this.prix,
    this.images,
  });

  factory Logement.fromJson(Map<String, dynamic> json) {
    return Logement(
      id: json['logement_id'],
      titre: json['titre'],
      description: json['description'],
      prix: json['prix'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
