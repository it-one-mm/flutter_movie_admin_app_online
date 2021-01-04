import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'my_text_form_field.dart';

class MySearch extends StatefulWidget {
  final TextEditingController searchController;
  final Function onClear;
  final void Function(String) onSearch;
  final String hintText;

  MySearch({
    this.searchController,
    this.onClear,
    this.onSearch,
    this.hintText = 'No Hint Text',
  }) : assert(searchController != null);

  @override
  _MySearchState createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: MyTextFormField(
        controller: widget.searchController,
        textInputAction: TextInputAction.search,
        decoration: kSearchInputDecoration.copyWith(
          hintText: widget.hintText,
          suffixIcon: widget.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: widget.onClear,
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {});
        },
        onFieldSubmitted: (String value) {
          if (widget.onSearch != null) widget.onSearch(value);
        },
      ),
    );
  }
}
