import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonService {
  Future<Pokemon> fetchPokemon(String pokemon) async {
    final search = pokemon.toLowerCase().trim();
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$search');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Pokemon.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw '$pokemon no existeix! Et sents com el JanoVGC al Barri Roig d"Amsterdam!';
      } else {
        throw 'Error de servidor (${response.statusCode})';
      }
    } catch (e) {
      if (e is String) throw Exception(e);
      throw Exception('Error de connexió! El Coletes et diu: Bona Sort al Dia 2 Company!');
    }
  }
}