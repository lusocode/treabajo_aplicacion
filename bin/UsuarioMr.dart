import "package:mysql1/mysql1.dart";
import "App.dart";

import "Database.dart";

class UsuarioMr {
  int? _idusuario;
  String? _nombre;
  String? _password;
  String? _correoElectronico;

  int? get idusuario => _idusuario;
  String? get nombre => _nombre;
  String? get password => _password;
  String? get correoElectronico => _correoElectronico;

  set nombre(String? nombre) => _nombre = nombre;
  set password(String? password) => _password = password;
  set correoElectronico(String? correoElectronico) =>
      _correoElectronico = correoElectronico;

  UsuarioMr();
  UsuarioMr.fromMap(ResultRow map) {
    _idusuario = map['idusuario'];
    _nombre = map['nombre'];
    _password = map['password'];
    _correoElectronico = map['correoElectronico'];
  }

  insertarUsuario() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO usuarios (nombre, password, correo) VALUES (?,?,?)',
          [_nombre, _password, _correoElectronico]);
      print('Usuario insertado correctamente');
      App().menuLogueado(UsuarioMr());
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  loginUsuario() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn
          .query('SELECT * FROM usuarios WHERE nombre = ?', [this._nombre]);
      UsuarioMr usuario = UsuarioMr.fromMap(resultado.first);
      if (this._password == usuario.password) {
        return usuario;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      await conn.close();
    }
  }
}
