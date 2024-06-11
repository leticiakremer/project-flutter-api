import 'package:flutter/material.dart';
import 'package:projetoflutterapi/src/models/character.dart';
import 'package:projetoflutterapi/src/models/episode.dart';
import 'package:projetoflutterapi/src/services/characters_api.dart';
import 'package:projetoflutterapi/src/widgets/character_image.dart';
import 'package:projetoflutterapi/src/widgets/character_info.dart';
import 'package:projetoflutterapi/src/widgets/episodes_list.dart';

class Details extends StatefulWidget {
  final Character character;

  const Details({Key? key, required this.character}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<Episode>> _episodes =
      ValueNotifier<List<Episode>>([]);
  final CharactersApi _charactersApi = CharactersApi();

  @override
  void initState() {
    super.initState();
    _fetchEpisodes();
  }

  void _fetchEpisodes() async {
    try {
      final episodes =
          await _charactersApi.fetchEpisodes(widget.character.episodes);
      _episodes.value = episodes;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              Expanded(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.green,
                ),
              ),
              Text('Voltar', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.2,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CharacterImage(
                imageUrl: widget.character.image,
                heroTag: widget.character.image,
              ),
              CharacterInfo(character: widget.character),
              ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return ValueListenableBuilder(
                    valueListenable: _episodes,
                    builder: (context, episodes, child) {
                      return EpisodesList(
                        episodes: episodes,
                        isLoading: isLoading,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
