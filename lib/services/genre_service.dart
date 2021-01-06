import 'package:cloud_firestore/cloud_firestore.dart';
import 'fs_service.dart';
import '../models/episode.dart';
import '../models/series.dart';
import '../models/movie.dart';
import '../utils/firestore_path.dart';
import '../models/genre.dart';

class GenreService extends FsService {
  GenreService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.genresCollection));

  Stream<List<Genre>> streamGenres() {
    return super
        .ref
        .orderBy(Genre.createdField, descending: true)
        .snapshots()
        .map((qs) => qs.docs
            .map((qdsn) => Genre.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }

  bool isExistName(List<Genre> list, String name) {
    final count = list
        .where((item) => item.name.toLowerCase() == name.toLowerCase())
        .toList()
        .length;

    if (count > 0) return true;
    return false;
  }

  @override
  Future<void> update(String docId, Map<String, dynamic> data) async {
    String name = data[Genre.nameField];

    final fs = FirebaseFirestore.instance;

    WriteBatch batch = fs.batch();

    batch.update(super.ref.doc(docId), data);

    final movieSnapshot = await fs
        .collection(FirestorePath.moviesCollection)
        .where(Movie.genreIdField, isEqualTo: docId)
        .get();
    for (var document in movieSnapshot.docs) {
      batch.update(document.reference, {Movie.genreNameField: name});
    }

    final seriesSnapshot = await fs
        .collection(FirestorePath.seriesCollection)
        .where(Series.genreIdField, isEqualTo: docId)
        .get();
    for (var document in seriesSnapshot.docs) {
      batch.update(document.reference, {Series.genreNameField: name});
    }

    return batch.commit();
  }

  @override
  Future<void> delete(String docId) async {
    final fs = FirebaseFirestore.instance;

    WriteBatch batch = fs.batch();

    batch.delete(super.ref.doc(docId));

    final movieSnapshot = await fs
        .collection(FirestorePath.moviesCollection)
        .where(Movie.genreIdField, isEqualTo: docId)
        .get();

    for (var document in movieSnapshot.docs) {
      batch.delete(document.reference);
    }

    final seriesSnapshot = await fs
        .collection(FirestorePath.seriesCollection)
        .where(Series.genreIdField, isEqualTo: docId)
        .get();

    for (var document in seriesSnapshot.docs) {
      final episodeSnapshot = await fs
          .collection(FirestorePath.episodesCollection)
          .where(Episode.seriesIdField, isEqualTo: document.id)
          .get();
      for (var element in episodeSnapshot.docs) {
        batch.delete(element.reference);
      }

      batch.delete(document.reference);
    }

    return batch.commit();
  }
}
