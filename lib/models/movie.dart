import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  Movie({
    this.id,
    this.title,
    this.imageUrl,
    this.key,
    this.genreId,
    this.genreName,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String key;
  final String genreId;
  final String genreName;

  static const String titleField = 'title';
  static const String imageUrlField = 'imageUrl';
  static const String keyField = 'key';
  static const String genreIdField = 'genreId';
  static const String genreNameField = 'genreName';
  static const String createdField = 'created';

  static Map<String, dynamic> toMap(Movie movie, {bool isNew = false}) {
    Map<String, dynamic> data = {
      titleField: movie.title,
      imageUrlField: movie.imageUrl,
      keyField: movie.key,
      genreIdField: movie.genreId,
      genreNameField: movie.genreName,
    };

    if (isNew) {
      data[createdField] = FieldValue.serverTimestamp();
    }

    return data;
  }

  factory Movie.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data();

    return Movie(
        id: doc.id,
        title: data[titleField],
        imageUrl: data[imageUrlField],
        key: data[keyField],
        genreId: data[genreIdField],
        genreName: data[genreNameField]);
  }
}
