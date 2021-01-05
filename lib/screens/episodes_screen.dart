import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'episode_form.dart';
import '../widgets/image_tile.dart';
import '../widgets/my_search.dart';
import '../models/episode.dart';
import '../widgets/master_view.dart';
import '../router.dart';

class EpisodesScreen extends StatefulWidget {
  @override
  _EpisodesScreenState createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final _searchController = TextEditingController();
  List<Episode> _filteredEpisodes = [];

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _handleSearch(String value, List<Episode> episodes) {
    if (value.trim().isNotEmpty) {
      _filteredEpisodes = episodes
          .where((episode) =>
              episode.seriesTitle.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    } else {
      _filteredEpisodes = episodes;
    }
  }

  void _clearSearch() {
    _filteredEpisodes = [];
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final episodes = Provider.of<List<Episode>>(context);
    final results =
        _filteredEpisodes.length == 0 ? episodes : _filteredEpisodes;

    return MasterView(
      title: 'Episodes',
      onCreate: () async {
        await Router.buildMaterialRoute(
          context,
          child: EpisodeForm(),
        );
        _clearSearch();
      },
      child: Column(
        children: [
          MySearch(
            searchController: _searchController,
            hintText: 'Search Series Title...',
            onSearch: (String value) {
              _handleSearch(value, episodes);
              setState(() {});
            },
            onClear: _clearSearch,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final episode = results[index];

                return ImageTile(
                  title: 'Episode ${episode.no}',
                  subTitle: episode.seriesTitle,
                  onEdit: () async {
                    await Router.buildMaterialRoute(
                      context,
                      child: EpisodeForm(
                        episode: episode,
                      ),
                    );
                    _clearSearch();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
