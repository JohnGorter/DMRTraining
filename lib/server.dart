import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SymbolServer extends ChangeNotifier {
  static SymbolServer? _instance;
  static get instance {
    if (_instance == null) {
      _instance = SymbolServer();
      _instance!.start();
    }
    return _instance;
  }

  List<int> airTemperatures = [];
  List<int> beanTemperatures = [];

  start() {
    Timer.periodic(Duration(seconds: 1), (t) async {
      Symbol s = await _fetchSymbol("airTemp");
      airTemperatures.add(s.value!.round());
      if (airTemperatures.length > 50) airTemperatures.removeAt(0);
      notifyListeners();
    });
  }

  Future<Symbol> _fetchSymbol(String symbol) async {
    http.Response response =
        await http.get(Uri.parse("https://e76d-185-10-158-5.ngrok.io/api/$symbol"));
    return Symbol.fromJSON(jsonDecode(response.body));
  }
}

class Symbol {
  String? name;
  double? value;
  Symbol({this.name, this.value});
  Symbol.fromJSON(Map<String, dynamic> json)
      : name = json.keys.first,
        value = json.values.first;
}