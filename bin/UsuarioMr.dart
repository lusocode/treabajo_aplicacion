import "package:mysql1/mysql1.dart";
import "App.dart";

import "Database.dart";

class UsuarioMr {
  String? _idusuario;
  String? _password;
  String? _correoElectronico;

  String? get idusuario => _idusuario;
  String? get password => _password;
  String? get correoElectronico => _correoElectronico;

  set idusuario(String? idusuario) => _idusuario = idusuario;
  set password(String? password) => _password = password;
  set correoElectronico(String? correoElectronico) =>
      _correoElectronico = correoElectronico;

  UsuarioMr();
  UsuarioMr.fromMap(ResultRow map) {
    _idusuario = map['idusuario'];
    _password = map['password'];
    _correoElectronico = map['correoElectronico'];
  }

  insertarUsuario() async {
    var conn = await Database().conexion();
    try {
      await conn.query(
          'INSERT INTO usuarios (idusuario, password, correo) VALUES (?,?,?)',
          [_idusuario, _password, _correoElectronico]);
      print('Usuario insertado correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  loginUsuario() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query(
          'SELECT * FROM usuarios WHERE idusuario = ?', [this._idusuario]);
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
