import 'package:flutter/material.dart' hide Router;
import '../widgets/master_view.dart';
import '../router.dart';
import 'movie_form.dart';

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MasterView(
      title: 'Movies',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: MovieForm());
      },
    );
  }
}
