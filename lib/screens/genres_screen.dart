import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import '../widgets/my_search.dart';
import '../router.dart';
import '../models/genre.dart';
import '../widgets/master_view.dart';
import 'genre_form.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final _searchController = TextEditingController();
  List<Genre> _filterGenres = [];

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _clearSearch() {
    _filterGenres = [];
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<List<Genre>>(context);
    final results = _filterGenres.length == 0 ? genres : _filterGenres;

    return MasterView(
      title: 'Genres',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: GenreForm());
        _clearSearch();
      },
      child: Column(
        children: [
          MySearch(
            searchController: _searchController,
            hintText: 'Search Genre...',
            onClear: _clearSearch,
            onSearch: (String value) {
              if (value.trim().isNotEmpty) {
                _filterGenres = genres
                    .where((genre) =>
                        genre.name.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              } else {
                _filterGenres = genres;
              }
              setState(() {});
            },
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final genre = results[index];

                return ListTile(
                  title: Text(genre.name),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Router.buildMaterialRoute(context,
                          child: GenreForm(genre: genre));

                      _clearSearch();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
