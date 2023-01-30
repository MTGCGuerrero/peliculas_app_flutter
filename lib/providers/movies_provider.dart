import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
// https://api.themoviedb.org/3/movie/now_playing?api_key=23f92fc8dc25d2d89f21df2e38e3091f&language=en-US&page=1
// yeah dont use the key if you see this derp
  final String _apiKey = "23f92fc8dc25d2d89f21df2e38e3091f";
  final String _baseUrl = "api.themoviedb.org";
  final String _language = "en-US";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

  // ignore: non_constant_identifier_names
  MoviesProvider() {
    // ignore: avoid_print
    print("MoviesProvider Inicializado");
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});
    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    // var url = Uri.https(_baseUrl, '3/movie/now_playing',
    //     {'api_key': _apiKey, 'language': _language, 'page': '1'});

    // // Await the http get response, then decode the json-formatted response.
    // final response = await http.get(url);
    final nowPlayingResponse =
        NowPlayingResponse.fromJson(jsonDecode(jsonData));
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    //print(nowPlayingResponse.results[0].title);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    // var url = Uri.https(_baseUrl, '3/movie/popular',
    //     {'api_key': _apiKey, 'language': _language, 'page': '1'});

    // // Await the http get response, then decode the json-formatted response.
    // final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(jsonDecode(jsonData));
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    //print(nowPlayingResponse.results[0].title);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }
}
