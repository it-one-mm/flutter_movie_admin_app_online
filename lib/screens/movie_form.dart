import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _keyController.dispose();

    super.dispose();
  }

  // Title, ImageUrl, Key, Genre

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Movie',
      formItems: [
        MyTextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Title *',
          ),
        ),
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
