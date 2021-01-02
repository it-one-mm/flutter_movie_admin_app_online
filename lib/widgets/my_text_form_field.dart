import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    this.controller,
    this.autocorrect = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.decoration,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final bool autocorrect;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final InputDecoration decoration;
  final Function validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final Function onChanged;
  final Function onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: decoration,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
