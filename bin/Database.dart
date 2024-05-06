import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Database {
  final String _host = 'localhost';
  final int _port = 3306;
  final String _user = 'root';

  instalacion() async {
    var settings = ConnectionSettings(
      host: this._host,
      port: this._port,
      user: this._user,
    );
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      await _crearTablaPeliculas(conn);
      await _crearTablaWatchedList(conn);
      await _crearTablaWishlist(conn);
      await conn.close();
    } catch (e) {
      print(e);
      await conn.close();
    }
  }

  Future<MySqlConnection> conexion() async {
    var settings = ConnectionSettings(
        host: this._host,
        port: this._port,
        user: this._user,
        db: 'movierecords');

    return await MySqlConnection.connect(settings);
  }

  _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS movierecords');
    await conn.query('USE movierecords');
    stdout.writeln('Conectado a movierecords');
  }

  _crearTablaUsuarios(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS usuarios(
        idusuario VARCHAR(20) NOT NULL PRIMARY KEY,
        password VARCHAR(10) NOT NULL,
        correo VARCHAR(50) NOT NULL UNIQUE
    )''');
    stdout.writeln('Tabla usuarios creada');
  }

  _crearTablaPeliculas(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS peliculas(
        idpelicula VARCHAR(15) NOT NULL PRIMARY KEY,
        titulo VARCHAR(50),
        lanzamiento VARCHAR (4),
        duracion VARCHAR(10),
        IMDB VARCHAR(10)
      )''');
    stdout.writeln('Tabla peliculas creada');
  }

  _crearTablaWatchedList(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS watchedlist(
    idpelicula VARCHAR (15) NOT NULL,
    idusuario VARCHAR(20) NOT NULL,
    title VARCHAR(50) NOT NULL,
    PRIMARY KEY (idpelicula, idusuario),
    FOREIGN KEY (idpelicula) REFERENCES peliculas (idpelicula),
    FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
  )''');
    stdout.writeln("Tabla Watchedlist creada");
  }

  _crearTablaWishlist(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS wishlist(
    idpelicula VARCHAR (15) NOT NULL,
    idusuario VARCHAR(20) NOT NULL,
    title VARCHAR (50) NOT NULL,
    PRIMARY KEY (idpelicula, idusuario),
    FOREIGN KEY (idpelicula) REFERENCES peliculas (idpelicula),
    FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
  )''');
    stdout.writeln("Tabla Wishlist creada");
  }
}
