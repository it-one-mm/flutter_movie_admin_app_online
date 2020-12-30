import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: MyTextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: kSearchInputDecoration.copyWith(
                hintText: 'Search Movie Title',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _clearSearch();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
              onFieldSubmitted: (String value) {
                if (value.trim().isNotEmpty) {
                  _filterMovies = movies
                      .where((movie) => movie.title
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                } else {
                  _filterMovies = movies;
                }

                setState(() {});
              },
            ),
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
