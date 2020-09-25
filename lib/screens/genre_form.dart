import 'package:flutter/material.dart';

class GenreForm extends StatefulWidget {
  @override
  _GenreFormState createState() => _GenreFormState();
}

class _GenreFormState extends State<GenreForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            autovalidate: true,
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // genre save
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
