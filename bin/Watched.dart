import "dart:io";
import "dart:convert";
import "package:http/http.dart" as http;
import "Movie.dart";
import "App.dart";
import "Database.dart";
import 'package:mysql1/mysql1.dart';

import "UsuarioMr.dart";

class Watchlist {
  String? _idpelicula;
  String? _idusuario;

  String? get idpelicula => this._idpelicula;
  String? get idusuario => this._idusuario;

  set idpelicula(String? idpelicula) => _idpelicula = idpelicula;
  set idusuario(String? idusuario) => _idusuario = idusuario;

  Watchlist();
  Watchlist.fromMap(ResultRow map) {
    this._idpelicula = map['idpelicula'];
    this._idusuario = map['idusuario'];
  }

  finalWatchedlist(UsuarioMr usuario) async {
    String? nombre = usuario.idusuario;
    int? opcion;
    do {
      stdout.writeln('''Hola $nombre, estás en tu Watchedlist, qué deseas hacer:
    1 - Añadir película
    2 - Borrar película
    3 - Mostrar tu lista Watchedlist
    4 - Salir ''');

      opcion = App().parsearOpcion();
    } while (watchedlistLogueada_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        addPelicula(usuario);
        break;
      case 2:
        // borrarDeWatchlist(watchlist);
        break;
      case 3:
        List<Movie> movies = mostrarWatchedlistFromUsuario();
        break;
      case 4:
        App().menuLogueado;
    }
  }

  addPelicula(UsuarioMr usuario) async {
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
        Movie pelicula = new Movie();
        pelicula.imdbID = bodyDetallado['imdbID'];
        pelicula.title = bodyDetallado['Title'];
        pelicula.year = bodyDetallado['Year'].toString();
        pelicula.runTime = bodyDetallado['Runtime'];
        pelicula.imbdRating = bodyDetallado['imdbRating'];
        pelicula.insertarMovie();
        print('pelicula añadida');
        stdin.readLineSync();
        Watchlist watchlist = new Watchlist();
        watchlist.idpelicula = bodyDetallado['imdbID'];
        watchlist.idusuario = usuario.idusuario;
        watchlist.insertarWatchedlist();
      } else if (respuesta.statusCode == 404) {
        throw ("La película que buscas no existe!");
      } else
        throw ("Ha habido un error de conexión");
    } catch (e) {
      stdout.writeln(e);
    }
  }

  insertarWatchedlist() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO watchedlist (idpelicula, idusuario) VALUES (?,?)',
          [_idpelicula, _idusuario]);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  mostrarWatchedlistFromUsuario(String? id) async {
    var conn = await Database().conexion();

    try {
      var resultado = await conn
          .query('SELECT * FROM watchedlist WHERE idusuario = ?', [id]);
      List<Movie> movies = resultado.map((row) => Movie.fromMap(row)).toList();
      return movies;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  int? parsearOpcion() => int.tryParse(stdin.readLineSync() ?? 'e');

  bool watchedlistLogueada_respuestaNoValida(int? opcion) =>
      opcion == null ||
      opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4;
}
