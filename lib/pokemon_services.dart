import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonService {
  Future<Pokemon> fetchPokemon(String pokemon) async { // fem future, ja que es un fetch, no retorna la req al instant.

    final search = pokemon.toLowerCase().trim(); // filtre per si l'usuari escriu malament!
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$search');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) { // 200 means correcte!
        return Pokemon.fromJson(jsonDecode(response.body));
      }
      else if (response.statusCode == 404) {
        throw Exception('El Pokémon "$pokemon" no existeix.');
      }
      else {
        throw Exception('Error de servidor (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error de connexió: Revisa el teu internet.');
    }
  }
}