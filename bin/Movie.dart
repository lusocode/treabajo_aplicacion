import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String year;
  final String imdbID;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
    );
  }
}
