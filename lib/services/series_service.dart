import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firestore_path.dart';

class SeriesService {
  static final _ref =
      FirebaseFirestore.instance.collection(FirestorePath.seriesCollection);

  static Future<void> saveSeries(Map<String, dynamic> data) async {
    await _ref.add(data);
  }
}
