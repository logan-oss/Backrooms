import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class DocumentManager {
  late File _jsonFile;
  late Directory _dir;
  late String fileName;
  bool _fileExists = false;
  late bool onReady = false;

  DocumentManager(String fileName) {
    getApplicationDocumentsDirectory().then((Directory directory) => {
          this.fileName = fileName,
          _dir = directory,
          _jsonFile = File(_dir.path + '/' + fileName),
          _fileExists = _jsonFile.existsSync(),
          onReady = true,
        });
  }

  void createFile(content) {
    List<String> list = [];
    list.add(jsonEncode(content));
    File file = File(_dir.path + '/' + fileName);
    file.createSync();
    _fileExists = true;
    file.writeAsStringSync(jsonEncode(list));
  }

  void deleteFile() {
    _jsonFile.delete();
  }

  void writeToFile(content) {
    if (_fileExists) {
      print("yes1");
      List<dynamic> list = [];
      list = jsonDecode(_jsonFile.readAsStringSync());
      list.add(jsonEncode(content));
      _jsonFile.writeAsStringSync(jsonEncode(list));
    } else {
      print("yes2");
      createFile(content);
    }
  }

  String readFile() {
    if (_fileExists)
      return _jsonFile.readAsStringSync();
    else
      return "";
  }
}
