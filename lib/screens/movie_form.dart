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
  MovieForm({this.movie});

  final Movie movie;

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
  bool _isExist = false;
  Movie _movie;

  @override
  void initState() {
    super.initState();

    _movie = widget.movie;
    _init();
  }

  void _init() async {
    _genres = context.read<List<Genre>>();

    if (_movie == null) {
      _selectedGenre = _genres[0];
    } else {
      _titleController.text = _movie.title;
      _imageUrlController.text = _movie.imageUrl;
      _keyController.text = _movie.key;

      _selectedGenre =
          _genres.where((genre) => genre.id == _movie.genreId).first;
    }
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

    if (_isExist) {
      _isExist = false;
      return 'Title is already taken!';
    }

    return null;
  }

  void _handleSave() async {
    final title = _titleController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final key = _keyController.text.trim();

    final result = await MovieService.checkDocumentByTitle(title);

    setState(() {
      if (result) {
        _isExist = true;
        _formKey.currentState.validate();
      }
    });

    if (!result) {
      final movie = Movie(
        title: title,
        imageUrl: imageUrl,
        key: key,
        genreId: _selectedGenre.id,
        genreName: _selectedGenre.name,
      );

      if (_movie == null) {
        await MovieService.saveMovie(Movie.toMap(movie, isNew: true));
      } else {
        await MovieService.updateMovie(_movie.id, Movie.toMap(movie));
        Navigator.pop(context);
      }

      UIHelper.showSuccessFlushbar(context, 'Movie saved successfully!');

      _formKey.currentState.reset();
      _titleController.clear();
      _imageUrlController.clear();
      _keyController.clear();
    }
  }

  void _handleDelete() async {
    await MovieService.deleteMovie(_movie.id);
    Navigator.pop(context);

    UIHelper.showSuccessFlushbar(context, 'Movie deleted successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: _movie == null ? 'Create Movie' : 'Edit Movie',
      model: _movie,
      handleSave: _handleSave,
      handleDelete: _handleDelete,
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
          validator: _validateKey,
        ),
      ],
    );
  }
}
