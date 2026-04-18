class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var typesFromJson = json['types'] as List;
    List<String> typesList = typesFromJson
        .map((t) => t['type']['name'].toString())
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      types: typesList,
      height: json['height'],
      weight: json['weight'],
    );
  }
}