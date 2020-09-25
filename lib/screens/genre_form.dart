import 'package:flutter/material.dart';
import '../utils/ui_helper.dart';
import '../models/genre.dart';
import '../services/genre_service.dart';
import '../widgets/progress_hud.dart';

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
  bool _isAsyncCall = false;
  bool _isExist = false;

  @override
  void initState() {
    super.initState();

    _genre = widget.genre;
    _init();
  }

  void _init() {
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

  void _handleSave() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isAsyncCall = true;
      });

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(FocusNode());

      final name = _nameController.text;

      // check genre already taken
      final result = await GenreService.checkDocumentsByName(name);
      setState(() {
        if (result) {
          _isExist = true;
          _formKey.currentState.validate();
        } else {
          _isExist = false;
        }
      });

      if (!result) {
        Genre genre = Genre(
          name: name,
        );

        if (_genre == null) {
          // genre save
          await GenreService.save(genre);
        } else {
          // update
          await GenreService.update(_genre.id, genre);
          Navigator.pop(context);
        }

        UIHelper.showSuccessFlushbar(context, 'Genre saved successfully!');

        _formKey.currentState.reset();
        _nameController.clear();
      }

      setState(() {
        _isAsyncCall = false;
      });
    }
  }

  void _handleDelete() async {
    setState(() {
      _isAsyncCall = true;
    });

    // delete
    await GenreService.delete(_genre.id);
    Navigator.pop(context);

    UIHelper.showSuccessFlushbar(context, 'Genre delete successfully!');

    setState(() {
      _isAsyncCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _genre == null ? 'Create Genre' : 'Edit Genre';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: ProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      errorStyle: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                    validator: _validateName,
                  ),
                  RaisedButton(
                    child: Text('SAVE'),
                    onPressed: _handleSave,
                  ),
                  _genre == null
                      ? Container()
                      : RaisedButton(
                          color: Colors.red,
                          child: Text('DELETE'),
                          onPressed: _handleDelete,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
