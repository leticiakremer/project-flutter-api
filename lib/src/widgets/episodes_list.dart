import 'package:flutter/material.dart';
import 'package:projetoflutterapi/src/models/episode.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> episodes;
  final bool isLoading;

  const EpisodesList({
    Key? key,
    required this.episodes,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        heightFactor: 4,
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF464646),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Episódios',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.green,
                      ),
                      Expanded(
                        child: Text(
                          episodes[index].name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
