import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  Genre({
    this.name,
  });

  final String name;

  static Map<String, dynamic> toMap(Genre genre) {
    return {
      'name': genre.name,
      'created': FieldValue.serverTimestamp(),
    };
  }
}
