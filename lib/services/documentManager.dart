import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class DocumentManager {
  Future<Directory> getRootPath() {
    return getApplicationDocumentsDirectory();
  }

  void createFile(QueryDocumentSnapshot<Object?> content, fileName, dir) {
    List<Map<String, dynamic>> list = [];
    content = content as QueryDocumentSnapshot<Object?>;
    Map<String, dynamic> contentData = content.data() as Map<String, dynamic>;
    contentData["release_modif"] =
        contentData["release_modif"].seconds.toString();
    contentData["id"] = content.id;
    list.add(contentData);
    File file = File(dir.path + '/' + fileName);
    file.createSync();
    file.writeAsStringSync(jsonEncode(list));
  }

  Future<void> deleteFile(fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    if (jsonFile.existsSync()) {
      jsonFile.delete();
    }
  }

  void resetData(String content, String fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    jsonFile.writeAsStringSync(content);
  }

  Future<String> writeToFile(
      QueryDocumentSnapshot<Object?> content, String fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);

    if (jsonFile.existsSync()) {
      // si le fichier existe, on le remplit avec les données initiales

      dynamic list = [];
      list = jsonDecode(jsonFile.readAsStringSync());

      Map<String, dynamic> contentData = content.data() as Map<String, dynamic>;
      contentData["release_modif"] =
          contentData["release_modif"].seconds.toString();
      contentData["id"] = content.id;

      dynamic localObject = findLocalObject(list, content.id);

      if (localObject != false) {
        // si l'objet existe déjà en local alors on le modifie
        list[list.indexOf(localObject)] = contentData;
      } else {
        list.add(contentData);
      }

      jsonFile.writeAsStringSync(jsonEncode(list));
    } else {
      createFile(content, fileName, dir);
    }
    return await readFile(fileName);
  }

  Future<String> readFile(fileName) async {
    Directory dir = await getRootPath();
    File jsonFile = File(dir.path + '/' + fileName);
    try {
      return jsonFile.readAsStringSync();
    } catch (e) {
      return '';
    }
  }

  dynamic findLocalObject(localList, id) {
    var object;
    try {
      object = localList.firstWhere((b) => b["id"] == id);
    } catch (e) {
      object = false;
    }
    return object;
  }
}
