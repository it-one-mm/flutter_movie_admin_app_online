import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/fs_service.dart';
import '../utils/firestore_path.dart';

class EpisodeService extends FsService {
  EpisodeService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.episodesCollection));
}
