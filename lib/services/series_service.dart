import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/series.dart';
import '../utils/firestore_path.dart';

class SeriesService {
  static final _ref =
      FirebaseFirestore.instance.collection(FirestorePath.seriesCollection);

  static bool checkByTitle(List<Series> list, String title) {
    final count = list
        .where((item) => item.title.toLowerCase() == title.toLowerCase())
        .toList()
        .length;

    if (count > 0) return true;
    return false;
  }

  static Stream<List<Series>> streamSeries() {
    return _ref.orderBy(Series.createdField, descending: true).snapshots().map(
        (qsn) => qsn.docs
            .map((qdsn) => Series.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }

  static Future<void> saveSeries(Map<String, dynamic> data) async {
    await _ref.add(data);
  }
}
