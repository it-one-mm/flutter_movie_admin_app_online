import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Router.GENRES_SCREEN,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
