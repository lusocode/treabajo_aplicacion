import "dart:io";
import "UsuarioMr.dart";
import "Watched.dart";
import 'Wishlist.dart';

class App {
  menuInicial() async {
    int? opcion;
    do {
      stdout.writeln('''Elige una opción
      1 - Crear usuario
      2 - Iniciar sesión''');
      opcion = parsearOpcion();
    } while (menuInicial_opcionNoValida(opcion));

    switch (opcion) {
      case 1:
        await creacionUsuario();
        break;
      case 2:
        await login();
        break;
    }
  }

  menuLogueado(UsuarioMr usuario) async {
    int? opcion;
    String? nombre = usuario.idusuario;

    do {
      stdout.writeln('''Hola, $nombre, elige una opción
      1 - Watchlist
      2 - Wishlist
      3 - Salir''');
      opcion = parsearOpcion();
    } while (menuLogueado_respuestaNoValida(opcion));
    switch (opcion) {
      case 1:
        await Watchedlist().finalWatchedlist(usuario);
        break;
      case 2:
        await Wishlist().finalWishlist(usuario);
        break;
      case 3:
        menuInicial();
        break;
    }
  }

  creacionUsuario() async {
    UsuarioMr usuarioMr = new UsuarioMr();

    stdout.writeln("Introduce un nombre de usuario");
    usuarioMr.idusuario = stdin.readLineSync() ?? "e";
    stdout.writeln("Introduce una contraseña");
    usuarioMr.password = stdin.readLineSync() ?? "e";
    stdout.writeln("Introduce un correo electrónico");
    usuarioMr.correoElectronico = stdin.readLineSync() ?? "e";
    usuarioMr.insertarUsuario();
    menuLogueado(usuarioMr);
  }

  int? parsearOpcion() => int.tryParse(stdin.readLineSync() ?? 'e');
  bool menuInicial_opcionNoValida(int? opcion) =>
      opcion == null || (opcion != 1 && opcion != 2);
  bool menuLogueado_respuestaNoValida(int? opcion) =>
      opcion == null || opcion != 1 && opcion != 2 && opcion != 3;

  login() async {
    UsuarioMr usuario = UsuarioMr();
    stdout.writeln('Introduce tu nombre de usuario');
    usuario.idusuario = stdin.readLineSync();
    stdout.writeln("Dime tu correo electrónico");
    usuario.correoElectronico = stdin.readLineSync();
    stdout.writeln('Introduce tu constraseña');
    usuario.password = stdin.readLineSync();
    var resultado = await usuario.loginUsuario();
    if (resultado == false) {
      stdout.writeln(
          'Tu nombre de usuario, correo electrónico o contraseña son incorrectos');
      menuInicial();
    } else {
      menuLogueado(resultado);
    }
  }

  // listarMoviesUsuario(String? id) async {
  //   var listaMovies = await Movie().mostrarWatchedlistFromUsuario(id);
  //   for (Movie elemento in listaMovies) {
  //     stdout.writeln("${elemento.imdbID} - ${elemento.title}");
  //   }
  //   return listaMovies;
  // }
}
