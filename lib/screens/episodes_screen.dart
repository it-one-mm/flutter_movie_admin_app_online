import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'episode_form.dart';
import '../widgets/image_tile.dart';
import '../models/episode.dart';
import '../widgets/master_view.dart';
import '../router.dart';

class EpisodesScreen extends StatefulWidget {
  @override
  _EpisodesScreenState createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  @override
  Widget build(BuildContext context) {
    final episodes = Provider.of<List<Episode>>(context);

    return MasterView(
      title: 'Episodes',
      onCreate: () async {
        await Router.buildMaterialRoute(
          context,
          child: EpisodeForm(),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];

                return ImageTile(
                  title: 'Episode ${episode.no}',
                  subTitle: episode.seriesTitle,
                  onEdit: () async {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
