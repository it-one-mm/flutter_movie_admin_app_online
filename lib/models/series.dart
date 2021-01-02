import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String genreId;
  final String genreName;

  Series({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.genreId,
    this.genreName,
  });

  static const String titleField = 'title';
  static const String imageUrlField = 'imageUrl';
  static const String descriptionField = 'description';
  static const String genreIdField = 'genreId';
  static const String genreNameField = 'genreName';
  static const String createdField = 'created';

  static Map<String, dynamic> toMap(Series series, {bool isNew = false}) {
    final Map<String, dynamic> data = {
      titleField: series.title,
      imageUrlField: series.imageUrl,
      descriptionField: series.description,
      genreIdField: series.genreId,
      genreNameField: series.genreName,
    };

    if (isNew) {
      data[createdField] = FieldValue.serverTimestamp();
    }

    return data;
  }

  factory Series.fromQueryDocumentSnapshot(QueryDocumentSnapshot qdsn) {
    final data = qdsn.data();

    return Series(
      id: qdsn.id,
      title: data[titleField],
      imageUrl: data[imageUrlField],
      genreId: data[genreIdField],
      genreName: data[genreNameField],
    );
  }
}
