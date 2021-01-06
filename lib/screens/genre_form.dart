import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../widgets/platform_aware_dialog.dart';
import '../utils/constants.dart';
import '../utils/ui_helper.dart';
import '../widgets/form_wrapper.dart';
import '../widgets/my_text_form_field.dart';
import '../models/genre.dart';
import '../services/genre_service.dart';

class GenreForm extends StatefulWidget {
  GenreForm({this.genre});

  final Genre genre;

  @override
  _GenreFormState createState() => _GenreFormState();
}

class _GenreFormState extends State<GenreForm> {
  Genre _genre;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isExist = false;
  List<Genre> _genres = [];
  GenreService _genreService;

  @override
  void initState() {
    super.initState();

    _genre = widget.genre;
    _init();
  }

  void _init() {
    _genreService = GetIt.instance<GenreService>();
    _genres = context.read<List<Genre>>();
    if (_genre != null) {
      _nameController.text = _genre.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  String _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }

    if (_isExist) {
      _isExist = false;
      return 'Name is already taken.';
    }

    return null;
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    // check genre already taken
    final result = _genreService.isExistName(_genres, name);

    if (result) {
      _isExist = true;
      _formKey.currentState.validate();
    }

    if (!result) {
      Genre genre = Genre(
        name: name,
      );

      if (_genre == null) {
        // genre save
        await _genreService.add(Genre.toMap(genre, isNew: true));
      } else {
        // update
        await _genreService.update(_genre.id, Genre.toMap(genre));
        Navigator.pop(context);
      }

      UIHelper.showSuccessFlushbar(context, 'Genre saved successfully!');

      _formKey.currentState.reset();
      _nameController.clear();
    }
  }

  void _handleDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PlatFormAwareDialog(
        title: 'Are you sure you want to delete?',
        actions: [
          FlatButton(
            onPressed: () async {
              Navigator.pop(_);
              await _genreService.delete(_genre.id);
              Navigator.pop(context);

              UIHelper.showSuccessFlushbar(
                  context, 'Genre delete successfully!');
            },
            child: Text('OK'),
            color: Colors.redAccent,
          ),
          FlatButton(
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _genre == null ? 'Create Genre' : 'Edit Genre';

    return FormWrapper(
      formKey: _formKey,
      appBarTitle: title,
      model: _genre,
      handleDelete: _handleDelete,
      handleSave: _handleSave,
      formItems: [
        MyTextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Name *',
          ),
          validator: _validateName,
        ),
      ],
    );
  }
}
