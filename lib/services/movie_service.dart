import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  static final _ref = FirebaseFirestore.instance.collection('movies');

  static Stream<List<Movie>> streamMovies() {
    return _ref.orderBy(Movie.createdField, descending: true).snapshots().map(
        (qsn) => qsn.docs
            .map((qdsn) => Movie.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }

  static Future<bool> checkDocumentByTitle(String title) async {
    final qsn = await _ref.get();

    for (var doc in qsn.docs) {
      final data = doc.data();
      final String titleValue = data[Movie.titleField];
      if (titleValue.toLowerCase() == title.toLowerCase()) {
        return true;
      }
    }

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
