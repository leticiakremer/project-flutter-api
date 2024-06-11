import 'package:flutter/material.dart';
import 'package:projetoflutterapi/src/models/character.dart';
import 'package:projetoflutterapi/src/pages/details.dart';
import 'package:projetoflutterapi/src/services/characters_api.dart';
import 'package:projetoflutterapi/src/widgets/character_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CharactersApi api = CharactersApi();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();

  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Character>> _charactersNotifier =
      ValueNotifier<List<Character>>([]);
  final ValueNotifier<List<Character>> _charactersFilteredNotifier =
      ValueNotifier<List<Character>>([]);
  final ValueNotifier<bool> _showScrollToTopButton = ValueNotifier<bool>(false);
  final FocusNode _focus = FocusNode();

  int page = 1;
  bool _isFiltering = false;
  Character? _lastCharacterClicked;

  @override
  void initState() {
    super.initState();
    _fetchCharacters(page);
    _scrollController.addListener(_scrollListener);
    _focus.unfocus();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _loading.dispose();
    _charactersNotifier.dispose();
    _charactersFilteredNotifier.dispose();
    _filterController.dispose();
    _showScrollToTopButton.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels <= 100) {
      _showScrollToTopButton.value = false;
    } else {
      _showScrollToTopButton.value = true;
    }
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_loading.value && !_isFiltering) {
        page++;
        await _fetchCharacters(page);
      }
    }
  }

  Future<void> _fetchCharacters(int page) async {
    _loading.value = true;
    List<Character> characters = await api.fetchCharacters(page);
    _charactersNotifier.value = [..._charactersNotifier.value, ...characters];
    if (!_isFiltering) {
      _charactersFilteredNotifier.value = _charactersNotifier.value;
    }
    _lastCharacterClicked ??= characters[0];
    _loading.value = false;
  }

  void _filterCharacters(String filter) async {
    if (filter.isEmpty) {
      _charactersFilteredNotifier.value = _charactersNotifier.value;
      _isFiltering = false;
      return;
    }

    _isFiltering = true;
    List<Character> filteredCharacters =
        await api.fetchCharactersFiltered(filter);
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            character: _lastCharacterClicked!,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                        child: ClipOval(
                            child: Image.network(
                          _lastCharacterClicked?.image ??
                              "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                          fit: BoxFit.fill,
                          height: 50,
                          width: 50,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _filterController,
                  onChanged: _filterCharacters,
                  cursorColor: Colors.green,
                  focusNode: _focus,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _filterCharacters("");
                        _filterController.clear();
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color.fromARGB(255, 73, 72, 72),
                    filled: true,
                    labelText: "Digite o nome do personagem",
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _focus.unfocus();
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: _loading,
                  builder: (context, loading, child) {
                    return ValueListenableBuilder<List<Character>>(
                      valueListenable: _charactersFilteredNotifier,
                      builder: (context, characters, child) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                !loading &&
                                !_isFiltering) {
                              _fetchCharacters(page);
                            }
                            return true;
                          },
                          child: GridView.builder(
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
                                    setState(() {
                                      _lastCharacterClicked = characters[index];
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Details(
                                          character: characters[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      CharacterImage(
                                        imageUrl: characters[index].image,
                                        heroTag: characters[index].image,
                                        height: 150,
                                        width: 150,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            characters[index].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTopButton,
        builder: (context, showButton, child) {
          return AnimatedOpacity(
            opacity: showButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              splashColor: Colors.green,
              backgroundColor: Colors.green,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
          );
        },
      ),
    );
  }
}
