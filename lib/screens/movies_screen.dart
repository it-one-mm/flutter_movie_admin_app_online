import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import '../widgets/image_tile.dart';
import '../models/movie.dart';
import '../widgets/master_view.dart';
import '../router.dart';
import 'movie_form.dart';

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<List<Movie>>(context);

    return MasterView(
      title: 'Movies',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: MovieForm());
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return ImageTile(
                  imageUrl: movie.imageUrl,
                  title: movie.title,
                  subTitle: movie.genreName,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
