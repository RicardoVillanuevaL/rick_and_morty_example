import 'dart:convert';

import 'package:rick_and_morty_example/core/models/characters_response.dart';
import 'package:http/http.dart' as http;

class RickAndMortyApi {

  static final _charactersUrl = "https://rickandmortyapi.com/api/character";
  static final _locationsUrl = "https://rickandmortyapi.com/api/location";
  static final _episodesUrl = "https://rickandmortyapi.com/api/episode";

  static Future<List<Character>> getCharacters() async {
    http.Response response = await http.get(_charactersUrl);
    if (response.statusCode == 200) 
      return CharactersResponse.fromJson(json.decode(response.body)).characters;
  }

}