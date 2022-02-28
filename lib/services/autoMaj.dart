import 'dart:convert';

import 'package:flutter/services.dart';

import './documentManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutoMaj {
  final DocumentManager _documentManager = DocumentManager();
  late List<dynamic> localBackroomsList;

  doTheMaj() async {
    String localContent = await getLocalContent();

    localBackroomsList = jsonDecode(localContent);
    setAllNewContent(Timestamp(
        await int.parse(localBackroomsList.last["release_modif"]), 0));
  }

  Future<String> getLocalContent() async {
    String localContent = await _documentManager.readFile("backrooms.json");
    if (localContent.isEmpty) {
      String contentFile =
          await rootBundle.loadString("assets/initData/backrooms.json");
      _documentManager.resetData(contentFile, "backrooms.json");
      return contentFile;
    } else {
      return localContent;
    }
  }

  Future<void> setAllNewContent(Timestamp lastUpDate) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('backrooms');

    final querySnapshot = collectionRef
        .where("release_modif", isGreaterThan: lastUpDate)
        .get()
        .then((document) {
      for (var backrooms in document.docs) {
        _documentManager.writeToFile(
            backrooms, "backrooms.json"); // get all data from a object
      }
    });
  }
}
