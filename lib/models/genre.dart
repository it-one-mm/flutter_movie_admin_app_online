import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  Genre({
    this.id,
    this.name,
  });

  final String id;
  final String name;

  static const String nameField = 'name';
  static const String createdField = 'created';

  factory Genre.fromQueryDocumentSnapshot(QueryDocumentSnapshot sn) {
    final data = sn.data();

    return Genre(
      id: sn.id,
      name: data[nameField],
    );
  }

  static Map<String, dynamic> toMap(Genre genre, {bool isNew = false}) {
    Map<String, dynamic> data = {
      nameField: genre.name,
    };

    if (isNew) {
      data[createdField] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
