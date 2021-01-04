import 'package:flutter/material.dart' hide Router;
import 'episode_form.dart';
import '../widgets/master_view.dart';
import '../router.dart';

class EpisodesScreen extends StatefulWidget {
  @override
  _EpisodesScreenState createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterView(
      title: 'Episodes',
      onCreate: () async {
        await Router.buildMaterialRoute(
          context,
          child: EpisodeForm(),
        );
      },
    );
  }
}
