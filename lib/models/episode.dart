import 'package:cloud_firestore/cloud_firestore.dart';

class Episode {
  final String id;
  final String no;
  final String seriesId;
  final String seriesTitle;
  final String key;

  Episode({
    this.id,
    this.no,
    this.seriesId,
    this.seriesTitle,
    this.key,
  });

  static const String noField = 'no';
  static const String keyField = 'key';
  static const String seriesIdField = 'seriesId';
  static const String seriesTitleField = 'seriesTitle';
  static const String createdField = 'created';

  Map<String, dynamic> toMap({bool isNew = false}) {
    final Map<String, dynamic> data = {
      noField: no,
      keyField: key,
      seriesIdField: seriesId,
      seriesTitleField: seriesTitle,
    };

    if (isNew) {
      data[createdField] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
