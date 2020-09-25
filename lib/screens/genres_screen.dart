import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../router.dart';
import '../models/genre.dart';
import '../widgets/master_view.dart';
import 'genre_form.dart';

class GenresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<List<Genre>>(context);

    return MasterView(
      title: 'Genres',
      onCreate: () {
        Router.buildMaterialRoute(context, child: GenreForm());
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          final genre = genres[index];

          return ListTile(
            title: Text(genre.name),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Router.buildMaterialRoute(context,
                    child: GenreForm(genre: genre));
              },
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: genres.length,
      ),
    );
  }
}
