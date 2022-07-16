import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:movies_app/env.dart';
import 'package:movies_app/helpers/debouncer.dart';
import '../models/models.dart';

class MovieProvider extends ChangeNotifier{

  final Map<String, dynamic> parameters = {
    "api_key" : Env.theMovieDBApiKey,
    "language" : "es-ES",
    "page" : "1"
  };

  List<Movie> nowPlayingMoviesList = [];
  List<Movie> popularMoviesList = [];

  int _popularPage = 0;

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  
  MovieProvider(){
    getNowPlayingDisplay();
    getPopularDisplay();
  }

  void getNowPlayingDisplay() async {

    nowPlayingMoviesList = await getListMovieData('/3/movie/now_playing') ?? [];

    notifyListeners();
  }

  void getPopularDisplay() async {

    _popularPage++;

    List<Movie> popularMoviesListAux = await getListMovieData( '3/movie/popular', _popularPage) ?? [];
    popularMoviesList = [ ...popularMoviesList, ...popularMoviesListAux ];

    notifyListeners();
  }

  Future<List<Movie>?> getListMovieData(String endpoint, [ int page = 1 ]) async {
    
    try {
      final url = Uri.https(Env.url, endpoint, {
        "api_key" : Env.theMovieDBApiKey,
        "language" : "es-ES",
        "page" : "$page"
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {

        final decodedData = json.decode(response.body);
        final List<dynamic> results = decodedData["results"];
        List<Movie> movies = List<Movie>.from( results.map((json) => Movie.fromJson(json)) );
        return movies;
        
      } else {
        print('statusCode 404');
        return null;
      }
    } catch (e) {

      print('e=$e');
      return null;
    }
  }

  Future<List<Cast>?> getCastByMovieId( int movieId ) async {
    
    try {

      if (moviesCast.containsKey(movieId)) return moviesCast[movieId];
        
      final url = Uri.https(Env.url, '/3/movie/$movieId/credits',{
        "api_key" : Env.theMovieDBApiKey,
        "language" : "es-ES",
      });

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final List<dynamic> casts = decodedData["cast"];

        final List<Cast> myCasts = List<Cast>.from( casts.map((json) => Cast.fromJson(json)) );

        moviesCast[movieId] = myCasts;

        return myCasts;
      }else{
        print('status 404');
        return null;
      }
      
    } catch (e) {
      print('e= $e');
      return null;
    }
  }

  Future<List<Movie>?> searchMovieByQuery(String query, [int page = 1]) async {
    try {

      final url = Uri.https(Env.url, '/3/search/movie',{
        "api_key"  : Env.theMovieDBApiKey,
        "language" : "es-ES",
        "query"    : query,
        "page"     : "$page"
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final List<dynamic> results = decodedData["results"];

        final List<Movie> movies = List<Movie>.from( results.map((json) => Movie.fromJson(json) ) );
        return movies;
      
      } else {
        print('statusError 404');
        return null;  
      }
      
    } catch (e) {
      print("e = $e");
      return null;  
    }
  }

  void getSuggestionsByQuery(String query) {

    debouncer.value = '';
    debouncer.onValue = (value) async {

      List<Movie> response = await searchMovieByQuery(value) ?? [];
      _suggestionStreamController.add(response);
      // _suggestionStreamController.sink.add(response);
      // print('tenemos valor a buscar = $value');
    };

    final timer =  Timer.periodic(const Duration(milliseconds: 300), (_){
      debouncer.value = query;
    });
    
    Future.delayed(const Duration(milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}