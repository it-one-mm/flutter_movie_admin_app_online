import 'package:flutter/material.dart' hide Router;
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  MovieTile({@required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          // 3 : 4
          minWidth: 45,
          minHeight: 60,
          maxWidth: 60,
          maxHeight: 80,
        ),
        child: Image.network(
          movie.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.genreName),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {},
      ),
    );
  }
}
