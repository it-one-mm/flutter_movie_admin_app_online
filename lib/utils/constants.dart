import 'package:flutter/material.dart';

const InputDecoration kFormFieldInputDecoration = InputDecoration(
  errorStyle: TextStyle(
    color: Color(0xff69f0ae),
  ),
);

const InputDecoration kSearchInputDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xFF444444),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide.none,
  ),
);
