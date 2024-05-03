import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'Database.dart';
import 'UsuarioMr.dart';

class Movie {
  String? _title;
  String? _year;
  String? _imdbID;
  int? _idusuario;
  int? _idwatchedlist;
  int? _idpelicula;

  String? get title => this._title;
  String? get year => this._year;
  String? get imdbID => this._imdbID;
  int? get idusuario => this._idusuario;
  int? get idwatchedlist => this._idwatchedlist;
  int? get idpelicula => this._idpelicula;

  set title(String? title) => _title = title;
  set year(String? year) => _year = year;
  set imdbID(String? imdbID) => _imdbID = imdbID;
  set idusuario(int? idusuario) => _idusuario = idusuario;
  set idwatchedlist(int? idwatchedlist) => _idwatchedlist = idwatchedlist;
  set idpelicula(int? idpelicula) => _idpelicula = idpelicula;

  Movie();
  Movie.fromMap(ResultRow map) {
    this._title = map['title'];
    this._year = map['year'];
    this._imdbID = map['imdbID'];
    this._idusuario = map['idusuario'];
    this._idwatchedlist = map['idwatchedlist'];
    this._idpelicula = map['idpelicula'];
  }

  insertarMovie() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO watchedlist ( titulo, año, idusuario, idwatchedlist, idpelicula) VALUES (?,?,?,?,?)',
          [_title, _year, _idusuario, _idwatchedlist, _idpelicula]);
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
