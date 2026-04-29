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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red,
        ),
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
        title: const Text('Pokédex: JanoVGC Edition',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
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
                      labelText: 'Nom o número de Pokédex',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscar,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.search, size: 25),
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
                        '${snapshot.error}'.replaceFirst('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final pokemon = snapshot.data!;
                    return SingleChildScrollView(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Image.network(
                                pokemon.imageUrl,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pokemon.name.toUpperCase(),
                                style: const TextStyle(fontSize: 28, color: Colors.black87),
                              ),
                              Text('Nº Pokédex: ${pokemon.id}', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                              const Divider(height: 40),
                              Text('Tipus: ${pokemon.types.join(', ')}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Altura', style: TextStyle(color: Colors.grey)),
                                      Text('${pokemon.height / 10} m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text('Pes', style: TextStyle(color: Colors.grey)),
                                      Text('${pokemon.weight / 10} kg', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Fes una cerca per començar!', style: TextStyle(color: Colors.grey)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}