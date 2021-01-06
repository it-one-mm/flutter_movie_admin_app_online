import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/episode.dart';
import '../services/fs_service.dart';
import '../utils/firestore_path.dart';

class EpisodeService extends FsService {
  EpisodeService()
      : super(FirebaseFirestore.instance
            .collection(FirestorePath.episodesCollection));

  bool isExistEpisode(List<Episode> list, String no, String seriesId,
      [String episodeId]) {
    final List<Episode> newList = [...list];

    if (episodeId != null) {
      newList.removeWhere((item) => item.id == episodeId);
    }

    final count = newList
        .where((item) => item.no == no && item.seriesId == seriesId)
        .length;
    if (count > 0) return true;

    return false;
  }

  Stream<List<Episode>> streamEpisodes() {
    return super
        .ref
        .orderBy(Episode.createdField, descending: true)
        .snapshots()
        .map((qs) => qs.docs
            .map((qdsn) => Episode.fromQueryDocumentSnapshot(qdsn))
            .toList());
  }
}
