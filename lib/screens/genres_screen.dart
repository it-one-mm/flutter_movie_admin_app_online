import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/genre.dart';
import 'genre_form.dart';
import '../widgets/master_view.dart';

class GenresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<List<Genre>>(context);

    return MasterView(
      title: 'Genres',
      onCreate: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreForm(),
            fullscreenDialog: true,
          ),
        );
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          final genre = genres[index];
          return ListTile(
            title: Text(genre.name),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: genres.length,
      ),
    );
  }
}
