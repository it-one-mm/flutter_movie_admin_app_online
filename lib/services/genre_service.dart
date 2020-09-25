import 'package:cloud_firestore/cloud_firestore.dart';

class GenreService {
  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('genres');

  static Future<bool> checkByName(String name) async {
    final qsn = await _ref.where('name', isEqualTo: name).get();
    if (qsn.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> save(Map<String, dynamic> map) async {
    await _ref.add(map);
  }
}
