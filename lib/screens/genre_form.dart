import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_admin_app/services/genre_service.dart';
import 'package:movie_admin_app/widgets/progress_hud.dart';

class GenreForm extends StatefulWidget {
  @override
  _GenreFormState createState() => _GenreFormState();
}

class _GenreFormState extends State<GenreForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool isAsynCall = false;

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
          inAsyncCall: isAsynCall,
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

                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isAsynCall = true;
                        });

                        // dismiss keyboard during async call
                        FocusScope.of(context).requestFocus(FocusNode());

                        final name = _nameController.text;

                        // genre save
                        await GenreService.save({
                          'name': name,
                          'created': FieldValue.serverTimestamp(),
                        });

                        _formKey.currentState.reset();
                        _nameController.clear();

                        setState(() {
                          isAsynCall = false;
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
