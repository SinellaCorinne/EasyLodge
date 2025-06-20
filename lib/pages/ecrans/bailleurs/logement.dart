class Logement {
  final int id;
  final String titre;
  final String description;
  final String prix;
  final List<String> images;

  Logement({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.images,
  });

  factory Logement.fromJson(Map<String, dynamic> json) {
    return Logement(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      prix: json['prix'].toString(),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'prix': prix,
      'images': images,
    };
  }
}
final logementMap = {
  'id': 1,
  'titre': 'Studio à Calavi',
  'description': 'Logement propre, climatisé',
  'prix': '15000',
  'localisation': 'Calavi',
  'disponibilite': true,
  'images': ['assets/images/logement.jpeg'],
};
