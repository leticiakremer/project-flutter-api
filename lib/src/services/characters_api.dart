import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetoflutterapi/src/models/character.dart';
import 'package:projetoflutterapi/src/models/episode.dart';
import 'package:projetoflutterapi/src/services/constants.dart';

class CharactersApi {
  static int pageLimit = 1;

  Future<List<Character>> fetchCharacters(int page) async {
    try {
      final response = await http.get(Uri.parse(
          '$BASE_URL/character/?page=${page <= pageLimit ? page : pageLimit}'));

      if (response.statusCode != 200) {
        throw Exception("Erro ao buscar os personagens");
      }

      final jsonResponse = json.decode(response.body);
      pageLimit = jsonResponse["info"]["pages"];
      var characterList = jsonResponse["results"] as List;
      List<Character> characters = characterList
          .map((jsonCharacter) => Character.fromJson(jsonCharacter))
          .toList();

      return characters;
    } catch (e) {
      throw Exception("Erro ao buscar os personagens: $e");
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
      throw Exception("Erro ao buscar os episódios: $e");
    }

    return episodes;
  }

  Future<List<Character>> fetchCharactersFiltered(String filter) async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/character?name=$filter'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((characterJson) => Character.fromJson(characterJson))
            .toList();
      } else {
        throw Exception('Erro ao buscar os personagens filtrados');
      }
    } catch (e) {
      throw Exception('Erro ao buscar os personagens filtrados: $e');
    }
  }
}
