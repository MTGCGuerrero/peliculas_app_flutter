import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_movies_response.dart';

class MoviesProvider extends ChangeNotifier {
// https://api.themoviedb.org/3/movie/now_playing?api_key=23f92fc8dc25d2d89f21df2e38e3091f&language=en-US&page=1
// yeah dont use the key if you see this derp
  final String _apiKey = "23f92fc8dc25d2d89f21df2e38e3091f";
  final String _baseUrl = "api.themoviedb.org";
  final String _language = "en-US";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;


  final debouncer = Debouncer(duration: const Duration(milliseconds: 500),
  onValue: (value) => null);



  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;
  // ignore: non_constant_identifier_names
  MoviesProvider() {
    // ignore: avoid_print
    print("MoviesProvider Inicializado");
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
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

  Future<List<Cast>> getMovieCast(int movieID) async {
    if (moviesCast.containsKey(movieID)) return moviesCast[movieID]!;

    final jsonData = await _getJsonData('3/movie/$movieID/credits');
    final creditsReponse = CreditResponse.fromJson(jsonDecode(jsonData));

    moviesCast[movieID] = creditsReponse.cast;

    return creditsReponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    final response = await http.get(url);
    final searchReponse = SearchResponse.fromJson(jsonDecode(response.body));

    return searchReponse.results;
  }


  void getSuggestionsByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async {
     
      final results = await searchMovies(searchTerm);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
