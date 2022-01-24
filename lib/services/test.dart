import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class Test {
  late File _jsonFile;
  late Directory _dir;
  late String fileName;
  bool _fileExists = false;
  late bool onReady = false;

  Test(String fileName) {
    fileName = fileName;
    getApplicationDocumentsDirectory().then((Directory directory) => {
          _dir = directory,
          _jsonFile = File(_dir.path + '/data/' + fileName),
          _fileExists = _jsonFile.existsSync(),
          onReady = true,
        });
  }

  Directory test() {
    return _dir;
  }
}
