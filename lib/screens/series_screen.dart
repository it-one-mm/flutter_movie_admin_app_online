import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'series_form.dart';
import '../widgets/my_search.dart';
import '../widgets/image_tile.dart';
import '../models/series.dart';
import '../router.dart';
import '../widgets/master_view.dart';

class SeriesScreen extends StatefulWidget {
  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final _searchController = TextEditingController();
  List<Series> _filterSeries = [];

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _onSearch(String value, List<Series> seriesList) {
    if (value.trim().isNotEmpty) {
      _filterSeries = seriesList
          .where((movie) =>
              movie.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      _filterSeries = seriesList;
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _filterSeries = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final seriesList = Provider.of<List<Series>>(context);
    final results = _filterSeries.length == 0 ? seriesList : _filterSeries;

    return MasterView(
      title: 'Series',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: SeriesForm());
        _clearSearch();
      },
      child: Column(
        children: [
          MySearch(
            searchController: _searchController,
            hintText: 'Search Series...',
            onSearch: (String value) {
              _onSearch(value, seriesList);
              setState(() {});
            },
            onClear: _clearSearch,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final series = results[index];

                return ImageTile(
                  imageUrl: series.imageUrl,
                  title: series.title,
                  subTitle: series.genreName,
                  onEdit: () async {
                    await Router.buildMaterialRoute(
                      context,
                      child: SeriesForm(
                        series: series,
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
