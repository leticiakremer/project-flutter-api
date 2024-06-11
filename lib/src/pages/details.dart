import 'package:flutter/material.dart';
import 'package:projetoflutterapi/src/models/character.dart';

class Details extends StatelessWidget {
  final Character character;

  const Details({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Hero(
                    tag: character.image,
                    child: Image.network(
                      character.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 98, 207, 101),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.star_border_outlined,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF302F2F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF464646),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Informações do personagem',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Localização: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                character.location,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Espécie: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                character.species,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF464646),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(character.episodes.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontFamily: 'Roboto',
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
