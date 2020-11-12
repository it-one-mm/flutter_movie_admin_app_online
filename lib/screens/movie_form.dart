import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/movie_service.dart';
import '../utils/ui_helper.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/form_wrapper.dart';

class MovieForm extends StatefulWidget {
  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _keyController = TextEditingController();

  List<Genre> _genres;
  Genre _selectedGenre;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    _genres = context.read<List<Genre>>();

    _selectedGenre = _genres[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _keyController.dispose();

    super.dispose();
  }

  Widget _buildDropDown() {
    List<DropdownMenuItem<Genre>> items = [];

    _genres.forEach((genre) {
      final dropDown = DropdownMenuItem<Genre>(
        child: Text(genre.name),
        value: genre,
      );

      items.add(dropDown);
    });

    return DropdownButton(
      value: _selectedGenre,
      items: items,
      onChanged: (value) {
        setState(() {
          _selectedGenre = value;
        });
      },
    );
  }

  String _validateImageUrl(String value) {
    if (value.trim().isEmpty) return 'Image Url is required!';

    return null;
  }

  String _validateKey(String value) {
    if (value.trim().isEmpty) return 'Key is required!';

    return null;
  }

  String _validateTitle(String value) {
    if (value.trim().isEmpty) return 'Title is required!';

    return null;
  }

  void _handleSave() async {
    final title = _titleController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final key = _keyController.text.trim();

    final movie = Movie(
      title: title,
      imageUrl: imageUrl,
      key: key,
      genreId: _selectedGenre.id,
      genreName: _selectedGenre.name,
    );

    await MovieService.saveMovie(Movie.toMap(movie, isNew: true));

    UIHelper.showSuccessFlushbar(context, 'movie saved successfully!');

    _formKey.currentState.reset();
    _titleController.clear();
    _imageUrlController.clear();
    _keyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Movie',
      handleSave: _handleSave,
      formItems: <Widget>[
        MyTextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Title *',
          ),
          validator: _validateTitle,
        ),
        _buildDropDown(),
        MyTextFormField(
          controller: _imageUrlController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Image Url *',
          ),
          validator: _validateImageUrl,
        ),
        MyTextFormField(
            controller: _keyController,
            decoration: kFormFieldInputDecoration.copyWith(
              labelText: 'Key *',
            ),
            validator: _validateKey),
      ],
    );
  }
}
