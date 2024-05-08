import 'App.dart';
import 'Movie.dart';
import "package:http/http.dart" as http;
import "dart:io";
import 'dart:convert';
import 'UsuarioMr.dart';
import 'package:mysql1/mysql1.dart';
import 'Database.dart';

class Wishlist {
  String? _idpelicula;
  String? _idusuario;
  String? _title;

  String? get idpelicula => this._idpelicula;
  String? get idusuario => this._idusuario;
  String? get title => this._title;

  set idpelicula(String? idpelicula) => _idpelicula = idpelicula;
  set idusuario(String? idusuario) => _idusuario = idusuario;
  set title(String? title) => _title = title;

  Wishlist();
  Wishlist.fromMap(ResultRow map) {
    this._idpelicula = map['idpelicula'];
    this._idusuario = map['idusuario'];
    this._title = map['title'];
  }

  finalWishlist(UsuarioMr usuario) async {
    String? nombre = usuario.idusuario;
    int? opcion;
    do {
      stdout.writeln('''Hola $nombre, estás en tu Wishlist, qué deseas hacer:
    1 - Añadir película
    2 - Borrar película
    3 - Mostrar tu lista Wishlist
    4 - Salir ''');

      opcion = App().parsearOpcion();
    } while (watchedlistLogueada_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        await addPeliculaWishlist(usuario);
        finalWishlist(usuario);
        break;
      case 2:
        await borrarPeliculaWishlist(usuario);
        finalWishlist(usuario);
        break;
      case 3:
        List<Wishlist> listaWishlist = await allWishlist(usuario.idusuario);
        for (Wishlist wish in listaWishlist) {
          stdout.writeln('La película que quieres ver es: ${wish._title}');
          finalWishlist(usuario);
        }
        break;
      case 4:
        App().menuLogueado(usuario);
        break;
    }
  }

  addPeliculaWishlist(UsuarioMr usuario) async {
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
        Movie pelicula = new Movie();
        pelicula.imdbID = bodyDetallado['imdbID'];
        pelicula.title = bodyDetallado['Title'];
        pelicula.year = bodyDetallado['Year'].toString();
        pelicula.runTime = bodyDetallado['Runtime'];
        pelicula.imbdRating = bodyDetallado['imdbRating'];
        await pelicula.insertarMovie();
        idpelicula = bodyDetallado['imdbID'];
        idusuario = usuario.idusuario;
        title = bodyDetallado['Title'];
        await insertarWishlist();
      } else if (respuesta.statusCode == 404) {
        throw ("La película que buscas no existe!");
      } else
        throw ("Ha habido un error de conexión");
    } catch (e) {
      stdout.writeln(e);
    }
  }

  insertarWishlist() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO wishlist (idpelicula, idusuario, title) VALUES (?,?,?)',
          [_idpelicula, _idusuario, _title]);
      print('Película añadida');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  allWishlist(String? id) async {
    var conn = await Database().conexion();
    try {
      var resultado =
          await conn.query('SELECT * FROM wishlist WHERE idusuario = ?', [id]);
      List<Wishlist> wishlist =
          resultado.map((row) => Wishlist.fromMap(row)).toList();
      return wishlist;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  borrarPeliculaWishlist(UsuarioMr usuario) async {
    var conn = await Database().conexion();
    try {
      List<Wishlist> listaWishlist = await allWishlist(usuario.idusuario);
      for (Wishlist watched in listaWishlist) {
        stdout.writeln('Quieres ver: ${watched._title}');
      }
      stdout.writeln('¿Qué película quieres borrar?');
      var opcion = stdin.readLineSync() ?? 'e';
      bool encontrado = false;
      for (Wishlist watched in listaWishlist) {
        if (watched._title == opcion) {
          await conn.query('DELETE FROM wishlist WHERE title = ?', [opcion]);
          stdout.writeln('Película borrada');
          encontrado = true;
          break;
        }
      }
      if (encontrado == false) {
        throw ('No se ha encontrado ninguna película con ese título');
      }
    } catch (e) {
      print(e);
      finalWishlist(usuario);
    } finally {
      await conn.close();
    }
  }

  bool watchedlistLogueada_respuestaNoValida(int? opcion) =>
      opcion == null ||
      opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4;
  int? parsearOpcion() => int.tryParse(stdin.readLineSync() ?? 'e');
}
