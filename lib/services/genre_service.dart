import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/genre.dart';

class GenreService {
  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('genres');

  static Stream<List<Genre>> streamGenres() {
    return _ref.orderBy('created', descending: true).snapshots().map((qs) =>
        qs.docs.map((qdsn) => Genre.fromQueryDocumentSnapshot(qdsn)).toList());
  }

  static Future<bool> checkDocumentsByName(String name) async {
    final qsn = await _ref.get();
    bool isExist = false;
    qsn.docs.forEach((element) {
      final data = element.data();
      String nameField = data['name'];

      if (name.toLowerCase() == nameField.toLowerCase()) {
        isExist = true;
      }
    });

    return isExist;
  }

  static Future<void> save(Genre genre) async {
    await _ref.add(Genre.toMap(genre, isNew: true));
  }

  static Future<void> update(String docId, Genre genre) async {
    await _ref.doc(docId).update(Genre.toMap(genre));
  }

  static Future<void> delete(String docId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.delete(_ref.doc(docId));

    QuerySnapshot qsn = await FirebaseFirestore.instance
        .collection('movies')
        .where('genreId', isEqualTo: docId)
        .get();

    qsn.docs.forEach((QueryDocumentSnapshot qdsn) {
      batch.delete(qdsn.reference);
    });

    batch.commit();
  }
}
