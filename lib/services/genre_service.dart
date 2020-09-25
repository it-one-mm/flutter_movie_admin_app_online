import 'package:cloud_firestore/cloud_firestore.dart';

class GenreService {
  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('genres');

  static Future<void> save(Map<String, dynamic> map) async {
    await _ref.add(map);
  }
}
