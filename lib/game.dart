import 'package:flutter/material.dart';
import 'dart:convert';
import './services/dataManager.dart';
import './services/soundPlayer.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _Game();
}

class _Game extends State<Game> {
  DataManager _dataManager = new DataManager();
  Map _backroom = {};
  Map _currentRoom = {};
  final soundPlayer = SoundPlayer();
  List<Widget> buttons = [];

  @override
  void initState() {
    super.initState();
    soundPlayer.init();
    getBackroom(0);
  }

  @override
  void dispose() {
    soundPlayer.stop();
    super.dispose();
  }

  //--------------- Initial Build -------------//
  @override
  Widget build(BuildContext context) {
    ImageProvider img = const NetworkImage(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
    if (_backroom["image"] != null) {
      img = MemoryImage(base64Decode(_backroom["image"]));
    }

    buttons = getScenarioButton();

    return Scaffold(
      body: Center(
        child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: ((_currentRoom["title"] != null) &&
                    (_backroom["id"] != null))
                ? Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height * 0.65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: img,
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: 80,
                            color: Colors.black54,
                            child: Text("Niveau " + _backroom["id"].toString(),
                                style: const TextStyle(fontSize: 40)),
                          ),
                          Flexible(
                              child: SingleChildScrollView(
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.all(15),
                                      padding: const EdgeInsets.all(15),
                                      color: Colors.grey.withOpacity(0.6),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                                Text(_currentRoom["title"],
                                                    style: const TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black)),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                const Text("Description : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                    _currentRoom["description"],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text("Actions :",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ] +
                                              getSolutions()))))
                        ]),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height * 0.35,
                        color: Colors.red.shade400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (buttons.length > 1)
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
                                    child: GridView.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        children: getScenarioButton()))
                                : SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Container(
                                      child: buttons[0],
                                    ))
                          ],
                        ),
                      ),
                    ],
                  )
                : ((_backroom["win"] != null)
                    ? AlertDialog(
                        title: const Text('Victoire !!!'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Text("Vous vous êtes échappé !"),
                          ],
                        ),
                        actions: <Widget>[
                          OutlinedButton(
                              onPressed: () {
                                replay();
                              },
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.blue.shade300,
                              ),
                              child: const Text("Rejouer")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.red.shade400,
                              ),
                              child: const Text("Quitter")),
                        ],
                      )
                    : Container())),
      ),
    );
  }

  getBackroom(int id) async {
    Map back = await _dataManager.getById(id);
    setState(() {
      _currentRoom = back;
      _backroom = back;
    });
    startSound();
  }

  List<Widget> getSolutions() {
    List solutions = [];
    if (_currentRoom == _backroom) {
      solutions = jsonDecode(_currentRoom["scenario"]);
    } else {
      solutions = _currentRoom["choices"];
    }

    List<Widget> solutionsWidg = [];
    if (_currentRoom["exit"] != null) {
      solutionsWidg.add(Text(
          "(sortie) Niveau " + _currentRoom["exit"].toString(),
          style: const TextStyle(fontSize: 18, color: Colors.black)));
    } else {
      int i = 1;
      for (var sol in solutions) {
        solutionsWidg.add(Text("($i) " + sol["title"],
            style: const TextStyle(fontSize: 18, color: Colors.black)));
        i++;
      }
    }

    return solutionsWidg;
  }

  List<Widget> getScenarioButton() {
    if (_currentRoom["title"] == null) {
      return [];
    }

    List solutions = [];

    if (_currentRoom == _backroom) {
      solutions = jsonDecode(_currentRoom["scenario"]);
    } else if (_currentRoom["choices"].length > 0) {
      solutions = _currentRoom["choices"];
    }

    List<Widget> solutionsWidg = [];

    if (_currentRoom["exit"] != null) {
      solutionsWidg.add(ElevatedButton(
        onPressed: () {
          getBackroom(_currentRoom["exit"]);
        },
        child: const Icon(Icons.exit_to_app),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            primary: Colors.green.shade100),
      ));
    } else {
      int i = 1;
      for (var sol in solutions) {
        solutionsWidg.add(ElevatedButton(
          onPressed: () {
            if ((sol["choices"].length > 0) || (sol["exit"] != null)) {
              setState(() {
                _currentRoom = sol;
              });
            } else {
              getBackroom(int.tryParse(_backroom["id"])
                  as int); // Pour éviter de rester bloquer au même endroit
            }
          },
          child: Text("${i}"),
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              primary: Colors.green.shade100),
        ));
        i++;
      }
    }
    return solutionsWidg;
  }

  void replay() {
    getBackroom(0);
  }

  void startSound() {
    String file = "";
    soundPlayer.stop();
    switch (_backroom["difficulty"]) {
      case "Sécurisé":
        file = "safe_level.mp3";
        break;
      case "Dangereux":
        file = "unsafe_level.mp3";
        break;
      case "Mortel":
        file = "danger_level.mp3";
        break;
    }

    soundPlayer.loop(file);
  }
}
