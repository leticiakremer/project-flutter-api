import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetoflutterapi/src/models/character.dart';
import 'package:projetoflutterapi/src/models/episode.dart';
import 'package:projetoflutterapi/src/services/constants.dart';

class CharactersApi {
  Future<List<Character>> fetchCharacters(int page) async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/character/?page=$page'));

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar os personagens");
      }

      var jsonResponse = json.decode(response.body)["results"] as List;
      List<Character> characters = [];

      for (var jsonCharacter in jsonResponse) {
        List<String> episodeUrls =
            List<String>.from(jsonCharacter['episode'] ?? []);
        List<Episode> episodes = await fetchEpisodes(episodeUrls);
        characters.add(Character.fromJson(jsonCharacter, episodes));
      }

      return characters;
    } catch (e) {
      throw Exception("Erro ao buscar os personagens");
    }
  }

  Future<List<Episode>> fetchEpisodes(List<String> episodeUrls) async {
    List<Episode> episodes = [];

    try {
      for (String url in episodeUrls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var jsonEpisode = json.decode(response.body);
          episodes.add(Episode.fromJson(jsonEpisode));
        }
      }
    } catch (e) {
      throw Exception("Erro ao buscar os episódios");
    }

    return episodes;
  }
}
