// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'info.dart';
import './game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backrooms',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List data = [];
    String dataString = jsonEncode(data);

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('backrooms');

    Future<void> getData() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      print(allData);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 80,
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: double.maxFinite,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        icon: Image.asset(
                          'assets/images/profile.png',
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: double.maxFinite,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        icon: Image.asset(
                          'assets/images/trophee.png',
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Align(
                child: Text(
                  "Backrooms",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 70,
                    fontFamily: 'Exquisite-Corpse',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getButtons(isPortrait),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getButtons(isPortrait) {
    if (isPortrait) {
      return [
        btnJouer(),
        const SizedBox(height: 20),
        btnCreer(),
        const SizedBox(height: 20),
        btnInfo(),
      ];
    }

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btnJouer(),
          const SizedBox(width: 20),
          btnCreer(),
        ],
      ),
    ];
  }

  Widget btnJouer() {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Game()),
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      color: Colors.blue.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: const Text(
        "Jouer",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget btnCreer() {
    return RaisedButton(
      onPressed: () {},
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      color: Colors.purple,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: const Text(
        "Créer",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget btnInfo() {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const InfoPage(title: 'Backrooms Infos')),
        );
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: const Icon(
        Icons.book,
        size: 30,
      ),
      padding: const EdgeInsets.all(16),
      shape: const CircleBorder(),
    );
  }
}
