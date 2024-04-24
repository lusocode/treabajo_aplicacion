import 'App.dart';
import 'Movie.dart';
import "package:http/http.dart" as http;
import "dart:io";
import 'dart:convert';

import 'UsuarioMr.dart';

class Wishlist {
  List<Movie> movies = [];

  void finalWishlist() async {
    String? movieTitle;
    stdout.writeln(
        "Hola cinéfilo, ingresa el título que quieres añadir a tu Wishlist");
    movieTitle = stdin.readLineSync() ?? "e";

    void mostrarWishlist() {
      if (movies.isEmpty) {
        stdout.writeln("La Wishlist está vacía");
      } else {
        for (var movie in movies) {
          stdout.writeln(
              "${movie.title} ${movie.year} - su puntuación en IMBD es ${movie.imdbID}");
        }
      }
    }
  }
}
