import 'package:mysql1/mysql1.dart';
import 'Database.dart';

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

  //MÉTODO PARA AÑADIR UNA PELÍCULA A LA BD
  insertarMovie() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO peliculas (idpelicula, titulo, lanzamiento, duracion, IMDB) VALUES (?,?,?,?,?)',
          [_imdbID, _title, _year, _runTime, _imdbRating]);
      print('Pelicula añadida');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  // MÉTODO PARA BORRAR UNA PELÍCULA DE LA BD
  borrarMovie() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'ALTER TABLE peliculas DROP (idpelicula, titulo, lanzamiento, duracion, IMDB)');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
