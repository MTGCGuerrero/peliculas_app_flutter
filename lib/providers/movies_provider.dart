import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MovieProvider extends ChangeNotifier {
  MoviesProvider() {
    print("MoviesProvider Inicializado");
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    print("GetOnDisplayMovies");
  }
}
