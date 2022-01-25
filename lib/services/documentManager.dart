import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class DocumentManager {

  Future<Directory> getRootPath(){
    return getApplicationDocumentsDirectory();
  }

  void createFile(content,fileName,dir) {
    File file = File(dir.path + '/' + fileName);
    file.createSync();
    print("hello");
    print(content);
    file.writeAsStringSync(content);
  }

  void deleteFile(fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    if(jsonFile.existsSync()) {
      jsonFile.delete();
    }
  }

  Future<String> writeToFile(content,fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    if (jsonFile.existsSync()) {
      List<dynamic> list = [];
      list = jsonDecode(jsonFile.readAsStringSync());
      list.add(jsonEncode(content));
      jsonFile.writeAsStringSync(jsonEncode(list));
    } else {
      createFile(content,fileName,dir);
    }
    return await readFile(fileName);
  }

  Future<String> readFile(fileName) async{
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    try {
      return jsonFile.readAsStringSync();
    } catch (e) {
      return '';
    }
  }
}
