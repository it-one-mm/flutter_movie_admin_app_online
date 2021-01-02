import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide Router;
import 'services/series_service.dart';
import 'models/movie.dart';
import 'models/series.dart';
import 'services/movie_service.dart';
import 'models/genre.dart';
import 'services/genre_service.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          initialData: <Genre>[],
          value: GenreService.streamGenres(),
        ),
        StreamProvider.value(
          initialData: <Movie>[],
          value: MovieService.streamMovies(),
        ),
        StreamProvider.value(
          initialData: <Series>[],
          value: SeriesService.streamSeries(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: Router.GENRES_SCREEN,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
