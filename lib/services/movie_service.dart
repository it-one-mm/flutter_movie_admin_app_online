import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static final _ref = FirebaseFirestore.instance.collection('movies');

  static Future<void> saveMovie(Map<String, dynamic> data) async {
    await _ref.add(data);
  }
}
