


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:movies_app/env.dart';

import 'package:http/http.dart' as http;
import 'package:movies_app/models/cast_model.dart';
import 'package:movies_app/models/movie_model.dart';

class MovieProvider extends ChangeNotifier{

  final Map<String, dynamic> parameters = {
    "api_key" : Env.theMovieDBApiKey,
    "language" : "es-ES",
    "page" : "1"
  };

  List<Movie> nowPlayingMoviesList = [];
  List<Movie> popularMoviesList = [];

  int _popularPage = 0;


  MovieProvider(){
    getNowPlayingDisplay();
    getPopularDisplay();
  }

  void getNowPlayingDisplay() async {

    nowPlayingMoviesList = await getNowPlaying() ?? [];

    notifyListeners();
  }

  void getPopularDisplay() async {

    _popularPage++;

    List<Movie> popularMoviesListAux = await getPopular(_popularPage) ?? [];
    popularMoviesList = [ ...popularMoviesList, ...popularMoviesListAux ];

    notifyListeners();
  }

  Future<List<Movie>?> getNowPlaying([ int page = 1 ]) async {
    
    try {

      final url = Uri.https(Env.url, '/3/movie/now_playing', {
        "api_key" : Env.theMovieDBApiKey,
        "language" : "es-ES",
        "page" : "$page"
      });
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {

        var decodedData = json.decode(response.body);
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

  Future<List<Movie>?> getPopular([ int page = 1 ]) async {
    
    try {

      final url = Uri.https(Env.url, '3/movie/popular', {
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

      final url = Uri.https(Env.url, '/3/movie/$movieId/credits',{
        "api_key" : Env.theMovieDBApiKey,
        "language" : "es-ES",
      });

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final List<dynamic> casts = decodedData["cast"];

        final List<Cast> myCasts = List<Cast>.from( casts.map((json) => Cast.fromJson(json)) );

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
}