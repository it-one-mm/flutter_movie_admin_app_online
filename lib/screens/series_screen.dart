import 'package:flutter/material.dart' hide Router;
import 'series_form.dart';
import '../router.dart';
import '../widgets/master_view.dart';

class SeriesScreen extends StatefulWidget {
  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterView(
        title: 'Series',
        onCreate: () async {
          await Router.buildMaterialRoute(context, child: SeriesForm());
        });
  }
}
