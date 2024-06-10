import 'package:flutter/material.dart';
import 'package:projetoflutterapi/services/characters_api.dart';
import 'models/character.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CharactersApi api = CharactersApi();

  late List<Character> _characters;
  late List<Character> _charactersFiltered;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<List<Character>> _fetchCharacters() async {
    _characters = await api.fetchCharacters();
    _charactersFiltered = _characters;

    return _characters;
  }

  //depois que filtrar, o setState vai atualizar a interface com os valores filtrados.
  _filterCharacters(String filter) {
    setState(() {
      _charactersFiltered = _characters.where((item) => item.name.toLowerCase().contains(filter.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Personagens"),
          backgroundColor: Colors.pink,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) {
                  _filterCharacters(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Filtro",
                ),
              ),
            ),
            FutureBuilder<List<Character>>(
                future: api.fetchCharacters(),
                builder: (context, snapshot) {
                  debugPrint(snapshot.connectionState.toString());
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                subtitle: Text(_charactersFiltered[index].name),
                                leading: Image.network(
                                    _charactersFiltered[index].image),
                              );
                            },
                            separatorBuilder: (_, __) {
                              return const Divider();
                            },
                            itemCount: _charactersFiltered.length),
                      ),
                    );
                  }
                  debugPrint(snapshot.error.toString());
                  return const CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
