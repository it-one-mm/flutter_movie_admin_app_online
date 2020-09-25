import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
import '../router.dart';
import '../models/genre.dart';
import '../widgets/master_view.dart';
import 'genre_form.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<List<Genre>>(context);

    return MasterView(
      title: 'Genres',
      onCreate: () {
        Router.buildMaterialRoute(context, child: GenreForm());
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: MyTextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: kSearchInputDecoration.copyWith(
                hintText: 'Search Genre Name',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
              onFieldSubmitted: (String value) {
                if (value.trim().isNotEmpty) {
                  print(value);
                }
              },
            ),
          ),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
