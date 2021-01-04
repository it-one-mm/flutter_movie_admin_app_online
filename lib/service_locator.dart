import 'package:get_it/get_it.dart';
import 'services/episode_service.dart';
import 'services/movie_service.dart';
import 'services/genre_service.dart';
import 'services/series_service.dart';

void setup() {
  GetIt.instance.registerLazySingleton(() => GenreService());
  GetIt.instance.registerLazySingleton(() => MovieService());
  GetIt.instance.registerLazySingleton(() => SeriesService());
  GetIt.instance.registerLazySingleton(() => EpisodeService());
}
