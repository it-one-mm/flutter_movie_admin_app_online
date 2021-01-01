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

  static Map<String, dynamic> toMap(Series series, {bool isNew = false}) {
    final Map<String, dynamic> data = {
      titleField: series.title,
      imageUrlField: series.imageUrl,
      descriptionField: series.description,
      genreIdField: series.genreId,
      genreNameField: series.genreName,
    };

    if (isNew) {
      data['created'] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
