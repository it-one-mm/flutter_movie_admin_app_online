import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../models/episode.dart';
import '../services/episode_service.dart';
import '../utils/ui_helper.dart';
import '../models/series.dart';
import '../utils/constants.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/form_wrapper.dart';

class EpisodeForm extends StatefulWidget {
  final Episode episode;

  EpisodeForm({this.episode});

  @override
  _EpisodeFormState createState() => _EpisodeFormState();
}

class _EpisodeFormState extends State<EpisodeForm> {
  final _formKey = GlobalKey<FormState>();
  final _noController = TextEditingController();
  final _keyController = TextEditingController();

  List<Series> _seriesList = [];
  Series _selectedSeries;
  Episode _episode;
  List<Episode> _episodes;
  EpisodeService _episodeService;
  bool _isExist = false;

  @override
  void initState() {
    super.initState();

    _episode = widget.episode;
    _init();
  }

  void _init() async {
    _episodes = context.read<List<Episode>>();
    _episodeService = GetIt.instance<EpisodeService>();
    _seriesList = context.read<List<Series>>();
    _selectedSeries = _seriesList?.first;
  }

  @override
  void dispose() {
    _noController.dispose();
    _keyController.dispose();

    super.dispose();
  }

  Widget _buildDropDown() {
    List<DropdownMenuItem<Series>> items = [];

    _seriesList.forEach((series) {
      final dropDown = DropdownMenuItem<Series>(
        child: Text(series.title),
        value: series,
      );

      items.add(dropDown);
    });

    return DropdownButton(
      value: _selectedSeries,
      items: items,
      onChanged: (value) {
        setState(() {
          _selectedSeries = value;
        });
      },
    );
  }

  String _validateNo(String val) {
    if (val.trim().isEmpty) return 'No is required!';

    final output = int.tryParse(val);
    if (output == null) {
      return 'No must be number.';
    } else if (output <= 0) {
      return 'Number must be greater than 0.';
    }

    if (_isExist) {
      _isExist = false;
      return 'No is already exist.';
    }

    return null;
  }

  String _validateKey(String val) {
    if (val.trim().isEmpty) return 'Key is required.';

    return null;
  }

  void _handleSave() async {
    final no = _noController.text.trim();
    final key = _keyController.text.trim();

    bool result = false;
    if (_episode == null) {
      result = _episodeService.isExistEpisode(
        _episodes,
        no,
        _selectedSeries.id,
      );
    }

    if (result) {
      _isExist = true;
      _formKey.currentState.validate();
    }

    if (!result) {
      Episode episode = Episode(
        no: no,
        key: key,
        seriesId: _selectedSeries.id,
        seriesTitle: _selectedSeries.title,
      );

      await _episodeService.add(episode.toMap(isNew: true));

      _formKey.currentState.reset();
      _noController.clear();
      _keyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBarTitle: 'Create Episode',
      model: _episode,
      handleSave: _handleSave,
      formItems: [
        MyTextFormField(
          controller: _noController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'No',
            hintText: 'Please Input Number',
          ),
          keyboardType: TextInputType.number,
          validator: _validateNo,
        ),
        _buildDropDown(),
        MyTextFormField(
          controller: _keyController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Key',
          ),
          validator: _validateKey,
        ),
      ],
    );
  }
}
