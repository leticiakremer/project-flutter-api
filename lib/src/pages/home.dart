import 'package:flutter/material.dart';
import 'package:projetoflutterapi/src/models/character.dart';
import 'package:projetoflutterapi/src/pages/details.dart';
import 'package:projetoflutterapi/src/services/characters_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CharactersApi api = CharactersApi();

  late ScrollController _scrollController;

  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Character>> _charactersNotifier =
      ValueNotifier<List<Character>>([]);
  final ValueNotifier<List<Character>> _charactersFilteredNotifier =
      ValueNotifier<List<Character>>([]);
  int page = 1;

  @override
  void initState() {
    super.initState();
    _fetchCharacters(page);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _fetchCharacters(page);
      }
    });
  }

  Future<void> _fetchCharacters(int page) async {
    _loading.value = true;
    List<Character> characters = await api.fetchCharacters(page);
    _charactersNotifier.value = [..._charactersNotifier.value, ...characters];
    _charactersFilteredNotifier.value = _charactersNotifier.value;
    _loading.value = false;
  }

  void _filterCharacters(String filter) {
    List<Character> filteredCharacters = _charactersNotifier.value
        .where((element) =>
            element.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    _charactersFilteredNotifier.value = filteredCharacters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rick And \nMorty",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Container(
                      height: 55,
                      width: 55,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 98, 207, 101),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 40,
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      _filterCharacters(value);
                    },
                    cursorColor: Colors.green,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color.fromARGB(255, 73, 72, 72),
                      filled: true,
                      labelText: "Digite o nome do personagem",
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _loading,
                    builder: (context, loading, child) {
                      return ValueListenableBuilder<List<Character>>(
                        valueListenable: _charactersFilteredNotifier,
                        builder: (context, characters, child) {
                          return GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 200,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: characters.length + (loading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == characters.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GridTile(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Details(
                                          character: characters[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            characters[index].image,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            characters[index].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
