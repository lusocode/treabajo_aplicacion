import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'Database.dart';
import 'UsuarioMr.dart';

class Movie {
  String? _imdbID;
  String? _title;
  String? _year;
  String? _runTime;
  String? _imdbRating;

  String? get imdbID => this._imdbID;
  String? get title => this._title;
  String? get year => this._year;
  String? get runTime => this._runTime;
  String? get imbdRating => this._imdbRating;

  set imdbID(String? imdbID) => _imdbID = imdbID;
  set title(String? title) => _title = title;
  set year(String? year) => _year = year;
  set runTime(String? runTime) => _runTime = runTime;
  set imbdRating(String? imbdRating) => _imdbRating = imbdRating;

  Movie();
  Movie.fromMap(ResultRow map) {
    this._imdbID = map['imdbID'];
    this._title = map['title'];
    this._year = map['year'];
    this._runTime = map['runTime'];
    this._imdbRating = map['imdbRating'];
  }

  insertarMovie() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO peliculas (idpelicula, titulo, lanzamiento, duracion, IMDB) VALUES (?,?,?,?,?)',
          [_imdbID, _title, _year, _runTime, _imdbRating]);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  mostrarWatchedlistFromUsuario(int? id) async {
    var conn = await Database().conexion();

    try {
      var resultado =
          await conn.query('SELECT * FROM peliculas WHERE idusuario = ?', [id]);
      List<Movie> movies = resultado.map((row) => Movie.fromMap(row)).toList();
      return movies;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
