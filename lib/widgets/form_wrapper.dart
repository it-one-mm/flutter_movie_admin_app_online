import 'package:flutter/material.dart';
import 'progress_hud.dart';

class FormWrapper extends StatefulWidget {
  FormWrapper({
    @required this.formKey,
    this.appBarTitle = 'No Title',
    this.model,
    this.handleDelete,
    this.handleSave,
    this.formItems,
  }) : assert(formKey != null);

  final List<Widget> formItems;
  final String appBarTitle;
  final formKey;
  final model;
  final Function handleDelete;
  final Function handleSave;

  @override
  _FormWrapperState createState() => _FormWrapperState();
}

class _FormWrapperState extends State<FormWrapper> {
  bool _isAsyncCall = false;

  void _handleSave() async {
    if (widget.formKey.currentState.validate()) {
      setState(() {
        _isAsyncCall = true;
      });

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(FocusNode());

      if (widget.handleSave != null) await widget.handleSave();

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
    if (widget.handleDelete != null) await widget.handleDelete();

    setState(() {
      _isAsyncCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: SafeArea(
        child: ProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: widget.formKey,
              child: ListView(
                children: [
                  if (widget.formItems != null) ...widget.formItems,
                  RaisedButton(
                    child: Text('SAVE'),
                    onPressed: _handleSave,
                  ),
                  widget.model == null
                      ? Container()
                      : RaisedButton(
                          color: Colors.red,
                          child: Text('DELETE'),
                          onPressed: _handleDelete,
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
