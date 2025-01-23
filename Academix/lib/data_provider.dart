import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  String _country;
  String _name;

  DataProvider(this._country, this._name);

  String get country => _country;
  set country(String value) {
    _country = value;
    notifyListeners();
  }

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
}