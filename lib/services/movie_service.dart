import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firestore_path.dart';
import '../models/movie.dart';

class MovieService {
  static final _ref =
      FirebaseFirestore.instance.collection(FirestorePath.moviesCollection);

  static Stream<List<Movie>> streamMovies() {
    return _ref.orderBy(Movie.createdField, descending: true).snapshots().map(
        (qsn) => qsn.docs
            .map((qdsn) => Movie.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }

  static bool checkByTitle(List<Movie> list, String title) {
    final count = list
        .where((item) => item.title.toLowerCase() == title.toLowerCase())
        .toList()
        .length;

    if (count > 0) return true;
    return false;
  }

  static Future<void> saveMovie(Map<String, dynamic> data) async {
    await _ref.add(data);
  }

  static Future<void> updateMovie(
      String docId, Map<String, dynamic> data) async {
    await _ref.doc(docId).update(data);
  }

  static Future<void> deleteMovie(String docId) async {
    await _ref.doc(docId).delete();
  }
}
