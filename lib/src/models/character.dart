import 'package:projetoflutterapi/src/models/episode.dart';
import 'package:projetoflutterapi/src/models/origen.dart';

class Character {
  final String name;
  final String image;
  final String status;
  final String type;
  final String gender;
  final Origin origin;
  final String location;
  final String species;
  final List<Episode> episodes;

  const Character({
    required this.name,
    required this.image,
    required this.status,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.species,
    required this.episodes,
  });

  factory Character.fromJson(
      Map<String, dynamic> json, List<Episode> episodes) {
    return Character(
      name: json["name"],
      image: json["image"],
      status: json["status"],
      type: json["type"],
      gender: json["gender"],
      origin: Origin.fromJson(json["origin"]),
      location: json["location"]['name'],
      species: json["species"],
      episodes: episodes,
    );
  }
}
