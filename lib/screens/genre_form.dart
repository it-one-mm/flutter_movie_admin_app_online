import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/genre_service.dart';
import '../widgets/progress_hud.dart';

class GenreForm extends StatefulWidget {
  @override
  _GenreFormState createState() => _GenreFormState();
}

class _GenreFormState extends State<GenreForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isAsyncCall = false;
  bool _isExist = false;

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Genre'),
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
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      errorStyle: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Name is required.';
                      }

                      if (_isExist) {
                        _isExist = false;
                        return 'Name is already taken.';
                      }

                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _isAsyncCall = true;
                        });

                        // dismiss keyboard during async call
                        FocusScope.of(context).requestFocus(FocusNode());

                        final name = _nameController.text;

                        // check genre already taken
                        final result =
                            await GenreService.checkDocumentsByName(name);
                        setState(() {
                          if (result) {
                            _isExist = true;
                            _formKey.currentState.validate();
                          } else {
                            _isExist = false;
                          }
                        });

                        if (!result) {
                          // genre save
                          await GenreService.save({
                            'name': name,
                            'created': FieldValue.serverTimestamp(),
                          });

                          _formKey.currentState.reset();
                          _nameController.clear();
                        }

                        setState(() {
                          _isAsyncCall = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
