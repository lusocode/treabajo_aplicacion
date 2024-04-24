import "Database.dart";
import "dart:io";
import "UsuarioMr.dart";
import "App.dart";

main() async {
  await Database().instalacion();
  await App().menuInicial();
  await App().menuLogueado;
}
