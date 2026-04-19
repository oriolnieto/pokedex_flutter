import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const PokedexHome(),
    );
  }
}

class PokedexHome extends StatefulWidget {
  const PokedexHome({super.key});

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  final PokemonService _service = PokemonService();
  final TextEditingController _controller = TextEditingController();

  Future<Pokemon>? _pokemonFuture;

  void _buscar() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _pokemonFuture = _service.fetchPokemon(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cercador Pokédex'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nom o número de Pokédex..',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscar,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Expanded(
              child: FutureBuilder<Pokemon>(
                future: _pokemonFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final pokemon = snapshot.data!;
                    return SingleChildScrollView(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Image.network(
                                pokemon.imageUrl,
                                height: 150,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                              ),
                              Text(
                                pokemon.name.toUpperCase(),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text('Nº Pokédex: ${pokemon.id}'),
                              const Divider(),
                              Text('Tipus: ${pokemon.types.join(', ')}'),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Altura: ${pokemon.height / 10} m'), // dividir ja que les dades venen en hectometres!
                                  Text('Pes: ${pokemon.weight / 10} kg'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Fes una cerca per començar!'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}