import 'package:cloud_firestore/cloud_firestore.dart';

class GenreService {
  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('genres');

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

  static Future<void> save(Map<String, dynamic> map) async {
    await _ref.add(map);
  }
}
