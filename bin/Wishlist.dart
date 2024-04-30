import 'App.dart';
import 'Movie.dart';
import "package:http/http.dart" as http;
import "dart:io";
import 'dart:convert';

import 'UsuarioMr.dart';

class Wishlist {
  String? apiKey = "a45fb635";

  finalWishlist(usuario) {
    String nombre = usuario.nombre;
    int? opcion;
    do {
      stdout.writeln('''Hola $nombre, estás en tu Watchedlist, qué deseas hacer:
    1 - Añadir película
    2 - Borrar película
    3 - Mostrar tu lista Wishlist
    4 - Salir ''');

      opcion = App().parsearOpcion();
    } while (watchedlistLogueada_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        addPelicula();
        break;
      case 2:
        // borrarDeWatchlist(watchlist);
        break;
      case 3:
        //mostrarWatchedlist(watchedlist);
        break;
      case 4:
        App().menuLogueado;
    }
  }

  addPelicula() async {
    String apiKey = "a45fb635";
    Uri url;
    stdout.writeln("¿Qué película deseas añadir?");
    String titulo = stdin.readLineSync() ?? "e";
    url = Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&s=$titulo');
    var respuesta = await http.get(url);
    try {
      if (respuesta.statusCode == 200) {
        var body = json.decode(respuesta.body);
        for (int i = 0; i < body['Search'].length; i++) {
          var titulo = body['Search'][i]['Title'];
          var year = body['Search'][i]['Year'];
          var idpelicula = i + 1;
          stdout.writeln(' $idpelicula: $titulo from $year');
        }
        stdout.writeln(
            "¿Qué película te interesa añadir a tu Wishlist?, introduce un número");
        var opcion = stdin.readLineSync() ?? "e";
        int? opcionint = int.tryParse(opcion);
        opcionint = opcionint! - 1;
        var seleccion = body['Search'][opcionint]['imdbID'];
        Uri url2 =
            Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&i=$seleccion');
        var detallesPelicula = await http.get(url2);
        var bodyDetallado = json.decode(detallesPelicula.body);
        stdout.writeln(bodyDetallado);
      } else if (respuesta.statusCode == 404) {
        throw ("La película que buscas no existe!");
      } else
        throw ("Ha habido un error de conexión");
    } catch (e) {
      stdout.writeln(e);
    }
  }

  bool watchedlistLogueada_respuestaNoValida(int? opcion) =>
      opcion == null ||
      opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4;
  int? parsearOpcion() => int.tryParse(stdin.readLineSync() ?? 'e');
}
