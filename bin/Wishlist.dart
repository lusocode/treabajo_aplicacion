import "dart:io";
import "dart:convert";
import "package:http/http.dart" as http;
import "UsuarioMr.dart";
import "App.dart";

class Wishlist {
  String? _apiKey = "a45fb635";

  finalWishlist(movie) {
    String? nombre = UsuarioMr().nombre;
    int? opcion;
    String? movie;

    do {
      stdout.writeln("Hola $nombre, ingresa el nombre de la película");
      movie = stdin.readLineSync() ?? "e";
      if (movie != null && movie.isNotEmpty) {
        stdout.writeln('''Qué deseas hacer
    1 - Añadir la película
    2 - Borrar la película
    3 - Mostrar tus películas de Watchlist
    4 - Volver al menú
    ''');
      }
      opcion = App().parsearOpcion();
    } while (watchlistLogueada_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        addAWatchlist(wishlist, movie);
        break;
      case 2:
        borrarDeWatchlist(watchlist, movie);
        break;
      case 3:
        mostrarWatchlist(watchlist);
        break;
      case 4:
        App().menuLogueado;
    }
  }

  Future<Map<String, dynamic>> buscarPelicula(String query) async {
    Uri url2 = Uri.parse('http://www.omdbapi.com/?apikey=$_apiKey&s=$query');
    final respuesta = await http.get(url2);
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw ("Error al cargar película");
    }
  }

  List<Map<String, dynamic>> addAWishlist(
      List<Map<String, dynamic>> watchlist, Map<String, dynamic> movie) {
    watchlist.add(movie);
    stdout.writeln("${movie["Title"]} añadida a Watchlist");
    return watchlist;
  }

  List<Map<String, dynamic>> borrarDeWatchlist(
      List<Map<String, dynamic>> watchlist, String titulo) {
    watchlist.removeWhere((movie) => movie['Title'] == titulo);
    stdout.writeln('$titulo ha sido borrado de su Watchlist');
    return watchlist;
  }

  void mostrarWatchlist(List<Map<String, dynamic>> watchlist) {
    stdout.writeln('Watchlist:');
    watchlist.forEach((movie) {
      print('${movie['Title']}');
    });
  }

  bool watchlistLogueada_respuestaNoValida(int? opcion) =>
      opcion == null ||
      opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4;
}