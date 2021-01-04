import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../utils/ui_helper.dart';
import '../models/series.dart';
import '../services/series_service.dart';
import '../models/genre.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/form_wrapper.dart';

class SeriesForm extends StatefulWidget {
  final Series series;

  SeriesForm({this.series});

  @override
  _SeriesFormState createState() => _SeriesFormState();
}

class _SeriesFormState extends State<SeriesForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Genre> _genres;
  List<Series> _seriesList = [];
  Genre _selectedGenre;
  bool _isExist = false;
  SeriesService _seriesService;
  Series _series;

  @override
  void initState() {
    super.initState();

    _series = widget.series;
    _init();
  }

  void _init() async {
    _seriesService = GetIt.instance<SeriesService>();
    _seriesList = context.read<List<Series>>();
    _genres = context.read<List<Genre>>();
    if (_series == null) {
      _selectedGenre = _genres[0];
    } else {
      _titleController.text = _series.title;
      _imageUrlController.text = _series.imageUrl;
      _descriptionController.text = _series.description;

      _selectedGenre =
          _genres.where((genre) => genre.id == _series.genreId).first;
    }
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

    bool result = false;

    if (_series == null) {
      result = _seriesService.isExistTitle(_seriesList, title);
    } else {
      result = _seriesService.isExistTitle(_seriesList, title, _series.id);
    }

    if (result) {
      _isExist = true;
      setState(() {});
      _formKey.currentState.validate();
    }

    if (!result) {
      final series = Series(
        title: title,
        imageUrl: imageUrl,
        description: description,
        genreId: _selectedGenre.id,
        genreName: _selectedGenre.name,
      );

      if (_series == null) {
        await _seriesService.add(Series.toMap(series, isNew: true));
      } else {
        await _seriesService.update(_series.id, Series.toMap(series));
        Navigator.pop(context);
      }

      _formKey.currentState.reset();
      _titleController.clear();
      _imageUrlController.clear();
      _descriptionController.clear();
    }
  }

  String _validateTitle(String val) {
    if (val.trim().isEmpty) return 'Title is required.';

    if (_isExist) {
      _isExist = false;
      return 'Title is already taken.';
    }

    return null;
  }

  String _validateImageUrl(String val) {
    if (val.trim().isEmpty) return 'Image Url is required.';

    return null;
  }

  void _handleDelete() async {
    await _seriesService.delete(_series.id);
    Navigator.pop(context);

    UIHelper.showSuccessFlushbar(context, 'Series deleted successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Series',
      model: _series,
      handleSave: _handleSave,
      handleDelete: _handleDelete,
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
