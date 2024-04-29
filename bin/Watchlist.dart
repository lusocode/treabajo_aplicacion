import "dart:io";
import "dart:convert";
import "package:http/http.dart" as http;
import "UsuarioMr.dart";
import "App.dart";

class Watchlist {
  String? _apiKey = "a45fb635";

  finalWatchlist(usuario) {
    List<Map<String, dynamic>> watchlist = [];
    String? nombre = usuario.nombre;
    int? opcion;

    do {
      stdout.writeln('''Hola $nombre, estás en tu Watchlist, qué deseas hacer
    1 - Añadir una película
    2 - Borrar una película
    3 - Mostrar tus películas de Watchlist
    4 - Volver al menú
    ''');
      opcion = App().parsearOpcion();
    } while (watchlistLogueada_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        addAWatchlist();
        break;
      case 2:
        // borrarDeWatchlist(watchlist);
        break;
      case 3:
        mostrarWatchlist(watchlist);
        break;
      case 4:
        App().menuLogueado;
    }
  }

  Future<void> addAWatchlist() async {
    String? apiKey = "a45fb635";
    stdout.writeln("Hola! ¿Qué película te interesa añadir?");
    String titulo = stdin.readLineSync() ?? "e";
    Uri url = Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&s=$titulo');
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
      } else if (respuesta.statusCode == 404) {
        throw ("El pokemon que buscas no existe!");
      } else
        throw ("Ha habido un error de conexión");
    } catch (e) {
      stdout.writeln(e);
    }
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
