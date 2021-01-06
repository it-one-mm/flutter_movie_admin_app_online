import 'package:cloud_firestore/cloud_firestore.dart';
import 'fs_service.dart';
import '../models/episode.dart';
import '../models/series.dart';
import '../utils/firestore_path.dart';

class SeriesService extends FsService {
  SeriesService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.seriesCollection));

  bool isExistTitle(List<Series> list, String title, [String updateId]) {
    final List<Series> newList = [...list];

    if (updateId != null) {
      newList.removeWhere((item) => item.id == updateId);
    }

    final count = newList
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

  @override
  Future<void> update(String docId, Map<String, dynamic> data) async {
    String title = data[Series.titleField];

    final fs = FirebaseFirestore.instance;

    WriteBatch batch = fs.batch();

    batch.update(super.ref.doc(docId), data);

    final episodeSnapshot = await fs
        .collection(FirestorePath.episodesCollection)
        .where(Episode.seriesIdField, isEqualTo: docId)
        .get();
    for (var document in episodeSnapshot.docs) {
      batch.update(document.reference, {Episode.seriesTitleField: title});
    }

    return batch.commit();
  }

  @override
  Future<void> delete(String docId) async {
    final fs = FirebaseFirestore.instance;

    WriteBatch batch = fs.batch();

    batch.delete(super.ref.doc(docId));

    final episodeSnapshot = await fs
        .collection(FirestorePath.episodesCollection)
        .where(Episode.seriesIdField, isEqualTo: docId)
        .get();
    for (var document in episodeSnapshot.docs) {
      batch.delete(document.reference);
    }

    return batch.commit();
  }
}
