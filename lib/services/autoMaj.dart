import 'dart:convert';

import 'package:flutter/services.dart';

import './documentManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutoMaj {

  final DocumentManager _documentManager = DocumentManager();
  late List<dynamic> localBackroomsList;
  
  doTheMaj() async{
    _documentManager.deleteFile("backrooms.json");
    String localContent = await getLocalContent();

    localBackroomsList = jsonDecode(localContent);
    setAllNewContent(Timestamp(int.parse(localBackroomsList.last["release_modif"]), 0));
  }

  Future<String> getLocalContent() async{
    String localContent = await _documentManager.readFile("backrooms.json");
    if(localContent.isEmpty){
      String contentFile = await rootBundle.loadString("assets/initData/backrooms.json");
      return await _documentManager.writeToFile(contentFile, "backrooms.json");
    }
    else{
      return localContent;
    }
  }

  Future<void> setAllNewContent(Timestamp lastUpDate) async{
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('backrooms');
      final querySnapshot = await collectionRef.where("release_modif", isGreaterThan: lastUpDate).get().then((document){
        List<dynamic> backroomsList = (document.docs.map((e) => e.data()).toList());
        for (var backrooms in backroomsList) {
          final backroomsLink = localBackroomsList.firstWhere((b) => b["id"] == backrooms["id"]);
          print(backroomsLink);
        }
      });
  }

}