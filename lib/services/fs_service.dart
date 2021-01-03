import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FsService {
  final CollectionReference ref;

  FsService(this.ref);

  Future<void> add(Map<String, dynamic> data) async {
    await ref.add(data);
  }

  Future<void> update(String docId, Map<String, dynamic> data) async {
    await ref.doc(docId).update(data);
  }

  Future<void> delete(String docId) async {
    await ref.doc(docId).delete();
  }
}
