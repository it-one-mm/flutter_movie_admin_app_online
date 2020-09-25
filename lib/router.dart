import 'package:flutter/material.dart';
import 'screens/genres_screen.dart';
import 'screens/movies_screen.dart';

class Router {
  static const String GENRES_SCREEN = 'genres_screen';
  static const String MOVIES_SCREEN = 'movies_screen';

  static Future buildMaterialRoute(BuildContext context,
      {Widget child, isFullScreen = true}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => child,
        fullscreenDialog: isFullScreen,
      ),
    );
  }

  static PageRouteBuilder<dynamic> _buildRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => widget,
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case GENRES_SCREEN:
        return _buildRoute(
          GenresScreen(),
        );
      case MOVIES_SCREEN:
        return _buildRoute(
          MoviesScreen(),
        );
    }

    return _buildRoute(
      Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
