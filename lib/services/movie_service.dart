import 'package:cloud_firestore/cloud_firestore.dart';
import 'fs_service.dart';
import '../utils/firestore_path.dart';
import '../models/movie.dart';

class MovieService extends FsService {
  MovieService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.moviesCollection));

  Stream<List<Movie>> streamMovies() {
    return super
        .ref
        .orderBy(Movie.createdField, descending: true)
        .snapshots()
        .map((qsn) => qsn.docs
            .map((qdsn) => Movie.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }

  bool isExistTitle(List<Movie> list, String title) {
    final count = list
        .where((item) => item.title.toLowerCase() == title.toLowerCase())
        .toList()
        .length;

    if (count > 0) return true;
    return false;
  }
}
