import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  Genre({
    this.id,
    this.name,
  });

  final String id;
  final String name;

  factory Genre.fromQueryDocumentSnapshot(QueryDocumentSnapshot sn) {
    final data = sn.data();

    return Genre(
      id: sn.id,
      name: data['name'],
    );
  }

  static Map<String, dynamic> toMap(Genre genre, {bool isNew = false}) {
    Map<String, dynamic> data = {
      'name': genre.name,
    };

    if (isNew) {
      data['created'] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
