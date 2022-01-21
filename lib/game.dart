import 'package:flutter/material.dart';
import 'dart:convert';

class Game extends StatelessWidget {
  Game({Key? key}) : super(key: key);

  final Map _jsonMap = {
    "name": "Le Tutoriel",
    "niveau": "0",
    "scenario" : [
      {"label":"choix1"},
      {"label":"choix2"},
      {"label":"choix3"}
    ]
  };

  @override
  Widget build(BuildContext context) {

    String jsonParse = jsonEncode(_jsonMap);
    Map stringParse = jsonDecode(jsonParse);
    
    return Scaffold(
      body: Container(
        child: Text("${stringParse['name']}"),
      ),
    );
  }
}
