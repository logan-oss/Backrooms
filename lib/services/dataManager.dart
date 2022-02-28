import 'dart:convert';

import 'package:flutter/services.dart';

import './documentManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataManager {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('backrooms');
  final DocumentManager _documentManager = DocumentManager();
  dynamic localBackrooms;

  DataManager() {
    initState();
  }

  initState() async {
    localBackrooms = await getBackrooms();
  }

  Future<bool> add(Map backroom) async {
    return await _collectionRef.get().then((QuerySnapshot querySnapshot) async {
      bool result = false;
      await _collectionRef
          .doc(querySnapshot.docs.length.toString())
          .set(backroom)
          .then((value) => result = true)
          .catchError((err) => result = false);
      return result;
    });
  }

  Future<Map> getById(int id) async {
    await dataIsLoaded();
    for (var backrooms in localBackrooms) {
      if (backrooms["id"] == id.toString()) {
        return backrooms;
      }
    }
    return {"win": "win"};
  }

  Future<dynamic> getBackrooms() async {
    return jsonDecode(await _documentManager.readFile("backrooms.json"));
  }

  Future<bool> dataIsLoaded() async {
    if (localBackrooms == null) {
      await Future.delayed(Duration(milliseconds: 100));
      return dataIsLoaded();
    } else
      return true;
  }
}
