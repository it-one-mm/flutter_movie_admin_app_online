import 'package:cloud_firestore/cloud_firestore.dart';
import 'fs_service.dart';
import '../models/series.dart';
import '../utils/firestore_path.dart';

class SeriesService extends FsService {
  SeriesService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.seriesCollection));

  bool isExistTitle(List<Series> list, String title) {
    final count = list
        .where((item) => item.title.toLowerCase() == title.toLowerCase())
        .toList()
        .length;

    if (count > 0) return true;
    return false;
  }

  Stream<List<Series>> streamSeries() {
    return super
        .ref
        .orderBy(Series.createdField, descending: true)
        .snapshots()
        .map((qsn) => qsn.docs
            .map((qdsn) => Series.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }
}
