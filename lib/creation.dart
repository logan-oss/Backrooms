import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
        ),
      ),
    );
  }
}
