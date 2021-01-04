import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import '../widgets/image_tile.dart';
import '../models/series.dart';
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
    final multiSeries = Provider.of<List<Series>>(context);

    return MasterView(
      title: 'Series',
      onCreate: () async {
        await Router.buildMaterialRoute(context, child: SeriesForm());
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: multiSeries.length,
              itemBuilder: (context, index) {
                final series = multiSeries[index];

                return ImageTile(
                  imageUrl: series.imageUrl,
                  title: series.title,
                  subTitle: series.genreName,
                  onEdit: () async {
                    await Router.buildMaterialRoute(
                      context,
                      child: SeriesForm(
                        series: series,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
