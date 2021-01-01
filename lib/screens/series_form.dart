import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/series.dart';
import '../services/series_service.dart';
import '../models/genre.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/form_wrapper.dart';

class SeriesForm extends StatefulWidget {
  @override
  _SeriesFormState createState() => _SeriesFormState();
}

class _SeriesFormState extends State<SeriesForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
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

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _handleSave() async {
    final title = _titleController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final description = _descriptionController.text.trim();

    final series = Series(
      title: title,
      imageUrl: imageUrl,
      description: description,
      genreId: _selectedGenre.id,
      genreName: _selectedGenre.name,
    );

    await SeriesService.saveSeries(Series.toMap(series, isNew: true));

    _formKey.currentState.reset();
    _titleController.clear();
    _imageUrlController.clear();
    _descriptionController.clear();
  }

  String _validateTitle(String val) {
    if (val.trim().isEmpty) return 'Title is required.';

    return null;
  }

  String _validateImageUrl(String val) {
    if (val.trim().isEmpty) return 'Image Url is required.';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Series',
      handleSave: _handleSave,
      formItems: [
        MyTextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Title',
          ),
          validator: _validateTitle,
        ),
        _buildDropDown(),
        MyTextFormField(
          controller: _imageUrlController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Image Url',
          ),
          validator: _validateImageUrl,
        ),
        MyTextFormField(
          controller: _descriptionController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Description (optional)',
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          minLines: 2,
        ),
      ],
    );
  }
}
