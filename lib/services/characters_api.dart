import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetoflutterapi/models/character.dart';
import 'package:projetoflutterapi/services/constants.dart';

class CharactersApi {
  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse('$BASE_URL/character'));

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar os personagens");
    }
    var jsonResponse = json.decode(response.body)["results"] as List;
    return jsonResponse.map((item) => Character.converter(item)).toList();
  }
}
