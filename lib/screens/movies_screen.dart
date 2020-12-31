import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import '../widgets/my_search.dart';
import '../widgets/image_tile.dart';
import '../models/movie.dart';
import '../widgets/master_view.dart';
import '../router.dart';
import 'movie_form.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _searchController = TextEditingController();
  List<Movie> _filterMovies = [];

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _clearSearch() {
    _filterMovies = [];
    _searchController.clear();
    setState(() {});
  }

  void _onSearch(String value, List<Movie> movies) {
    if (value.trim().isNotEmpty) {
      _filterMovies = movies
          .where((movie) =>
              movie.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      _filterMovies = movies;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<List<Movie>>(context);
    final results = _filterMovies.length == 0 ? movies : _filterMovies;

    return MasterView(
      title: 'Movies',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: MovieForm());
        _clearSearch();
      },
      child: Column(
        children: [
          MySearch(
            searchController: _searchController,
            hintText: 'Search Movie...',
            onSearch: (String value) {
              _onSearch(value, movies);
              setState(() {});
            },
            onClear: _clearSearch,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final movie = results[index];

                return ImageTile(
                  imageUrl: movie.imageUrl,
                  title: movie.title,
                  subTitle: movie.genreName,
                  onEdit: () async {
                    await Router.buildMaterialRoute(
                      context,
                      child: MovieForm(movie: movie),
                    );
                    _clearSearch();
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
