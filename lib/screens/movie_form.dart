import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // Title, ImageUrl, Key, Genre

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Movie',
      formItems: <Widget>[
        MyTextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Title *',
          ),
        ),
        _buildDropDown(),
        MyTextFormField(
          controller: _imageUrlController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Image Url *',
          ),
        ),
        MyTextFormField(
          controller: _keyController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Key *',
          ),
        ),
      ],
    );
  }
}
