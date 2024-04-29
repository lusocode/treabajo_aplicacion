import "dart:ffi";

import "package:http/http.dart" as http;
import "dart:io";
import "dart:convert";

main() async {
  String apiKey = "a45fb635";
  Uri url;

  url = Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&s=Spiderman');
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
          "¿Qué película te interesa añadir a tu Watchlist?, introduce un número");
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
      throw ("El pokemon que buscas no existe!");
    } else
      throw ("Ha habido un error de conexión");
  } catch (e) {
    stdout.writeln(e);
  }
}
