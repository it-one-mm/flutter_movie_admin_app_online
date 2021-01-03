import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/series.dart';
import '../services/fs_service.dart';
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
  Future<void> delete(String docId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.delete(super.ref.doc(docId));

    QuerySnapshot qsn;
    qsn = await FirebaseFirestore.instance
        .collection(FirestorePath.moviesCollection)
        .where(Movie.genreIdField, isEqualTo: docId)
        .get();

    qsn.docs.forEach((QueryDocumentSnapshot qdsn) {
      batch.delete(qdsn.reference);
    });

    qsn = await FirebaseFirestore.instance
        .collection(FirestorePath.seriesCollection)
        .where(Series.genreIdField, isEqualTo: docId)
        .get();

    qsn.docs.forEach((QueryDocumentSnapshot qdsn) {
      batch.delete(qdsn.reference);
    });

    batch.commit();
  }
}
