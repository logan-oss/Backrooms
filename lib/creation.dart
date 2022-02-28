import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import './services/dataManager.dart';

class Creation extends StatefulWidget {
  const Creation({Key? key}) : super(key: key);

  @override
  State<Creation> createState() => _Creation();
}

//----------------------------------------------------------------//
//------------------------ Initialisation ------------------------//
//----------------------------------------------------------------//

class _Creation extends State<Creation> {
  Map<String, dynamic> _backroom = {};
  List<Map> _scenario = [];
  Map<String, bool> _scenarioVisibility = {};
  DataManager _dataManager = new DataManager();

  //--------------- Initial Build -------------//
  @override
  Widget build(BuildContext context) {
    print(_scenario);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "Créer une backrooms",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                width: double.infinity,
                height: 80,
                color: Colors.red.shade400,
                child: getBarScenario(),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getScenario())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validation,
        tooltip: 'Increment',
        child: const Icon(Icons.check),
      ),
    );
  }

  //----------------------------------------------------------------//
  //----------------------- Function section -----------------------//
  //----------------------------------------------------------------//

  void _validation() async {
    _backroom["scenario"] = jsonEncode(_scenario);
    _backroom["release_modif"] = DateTime.now();
    bool valid = await _dataManager.add(_backroom);
    if (await valid) {
      Navigator.of(context).pop();
    }
  }

  Widget getBarScenario() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text("Scénario : ", style: TextStyle(fontSize: 30))),
              Container(
                  child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add_box),
                    alignment: Alignment.topLeft,
                    iconSize: 60,
                    onPressed: () {
                      addChoice([]);
                    },
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getScenario() {
    List<Widget> scenarioBar = getAllChoices(_scenario, []);

    return scenarioBar;
  }

  addChoice(List<int> path) {
    //print("add choice : $path");
    String pathString = jsonEncode(path);
    // faire une autre fonction avec en paramettre un tableau pour le chemin jusqu'au choix
    if ((path.length == 0)) {
      if ((_scenario.length < 4)) {
        setState(() {
          _scenario.add({'title': "", 'description': "", 'choices': []});
        });
      }
    } else {
      setState(() {
        Map<dynamic, dynamic> choices = _scenario[path[0]];

        for (var i = 1; i < path.length; i++) {
          choices = choices["choices"][path[i]];
        }
        choices["choices"].add({'title': '', 'description': '', 'choices': []});
      });
    }
  }

  deleteChoice(List<int> path) {
    setState(() {
      if (path.length > 1) {
        Map<dynamic, dynamic> choices = _scenario[path[0]];

        for (var i = 1; i < path.length - 1; i++) {
          choices = choices["choices"][path[i]];
        }
        choices["choices"].removeAt(path.last);
      } else {
        _scenario.removeAt(path.last);
      }
    });
  }

  addExit(List<int> path) {
    setState(() {
      Map<dynamic, dynamic> choices = _scenario[path[0]];

      for (var i = 1; i < path.length; i++) {
        choices = choices["choices"][path[i]];
      }

      choices["exit"] = 0;
    });
  }

  String getTitle(List<int> path) {
    if (path.length == 0) {
      if (_backroom["title"] == null) {
        return "";
      }

      return _backroom["title"];
    }

    Map<dynamic, dynamic> choices = _scenario[path[0]];

    for (var i = 1; i < path.length; i++) {
      choices = choices["choices"][path[i]];
    }

    return choices["title"];
  }

  String getDescription(List<int> path) {
    if (path.length == 0) {
      if (_backroom["description"] == null) {
        return "";
      }

      return _backroom["description"];
    }

    Map<dynamic, dynamic> choices = _scenario[path[0]];

    for (var i = 1; i < path.length; i++) {
      choices = choices["choices"][path[i]];
    }

    return choices["description"];
  }

  dynamic getExit(List<int> path) {
    if (path.length == 0) {
      return false;
    }
    Map<dynamic, dynamic> choices = _scenario[path[0]];

    for (var i = 1; i < path.length; i++) {
      choices = choices["choices"][path[i]];
    }

    if (choices["exit"] != null) {
      return choices["exit"];
    } else
      return false;
  }

  modifTitle(List<int> path, String title) {
    setState(() {
      if (path.length == 0) {
        _backroom["title"] = title;
      } else {
        Map<dynamic, dynamic> choices = _scenario[path[0]];

        for (var i = 1; i < path.length - 1; i++) {
          choices = choices["choices"][path[i]];
        }
        choices["title"] = title;
      }
    });
  }

  modifDescr(List<int> path, String description) {
    setState(() {
      if (path.length == 0) {
        _backroom["description"] = description;
      } else {
        Map<dynamic, dynamic> choices = _scenario[path[0]];

        for (var i = 1; i < path.length - 1; i++) {
          choices = choices["choices"][path[i]];
        }
        choices["description"] = description;
      }
    });
  }

  modifLevel(List<int> path, int level) {
    setState(() {
      if (path.length == 0) {
      } else {
        Map<dynamic, dynamic> choices = _scenario[path[0]];

        for (var i = 1; i < path.length; i++) {
          choices = choices["choices"][path[i]];
        }
        choices["exit"] = level;
      }
    });
  }

  modifDifficulty(String difficulty) {
    setState(() {
      _backroom["difficulty"] = difficulty;
    });
  }

  modifNbEntity(String nbEntity) {
    setState(() {
      _backroom["entities_count"] = nbEntity;
    });
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        final bytes = File(pickedFile.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);
        _backroom["image"] = base64Image;
      });
    }
  }

  List<Widget> getAllChoices(List<dynamic> choices, List<int> path) {
    List<Widget> widgList = [];
    // ajout d'un titre et d'une description à un choix (obligatoire)
    widgList.add(addTitleWidget(
        [...path], 50 * (path.length).toDouble(), getTitle(path)));
    widgList.add(addDescriptionWidget(
        [...path], 50 * (path.length).toDouble(), getDescription(path)));

    if (path.length == 0) {
      widgList.add(addPicture());
      widgList.add(addDifficulty());
    }

    dynamic exit = getExit(path);
    if (exit != false) {
      widgList
          .add(addExitWidget([...path], 50 * (path.length).toDouble(), exit));
    }

    // initialisation de la position des choix fils à 0
    path.add(0);
    for (var i = 0; i < choices.length; i++) {
      // parcour des choix fils
      path[path.length - 1] = i; // i = position du choix

      exit = getExit(path);

      String choiceId = path
          .map((i) => i.toString())
          .join(""); // id d'un choix généré à l'aide du chemin qui est unique

      widgList.add(addChoiceWidget(
          // création de du container d'un choix
          [...path],
          50 * (path.length - 1).toDouble(),
          choiceId,
          _scenarioVisibility[choiceId] == false
              ? Icons.expand_more
              : Icons.expand_less));

      if (choices[i]["choices"].length > 0) {
        // si le choix présent à des fils
        List<dynamic> choicesOf = choices[i]["choices"];
        widgList.add(Visibility(
            visible: _scenarioVisibility[choiceId] == false ? false : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getAllChoices(choicesOf, List.from(path)),
            )));
      } else if (choices[i]["choices"].length == 0) {
        // si le choix présent n'à pas de fils ajouter le titre et la description
        widgList.add(Visibility(
            visible: _scenarioVisibility[choiceId] == false ? false : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addTitleWidget([...path, 0], 50 * (path.length).toDouble(),
                    getTitle(path)),
                addDescriptionWidget([...path, 0],
                    50 * (path.length).toDouble(), getDescription(path)),
                if (exit != false)
                  addExitWidget([...path], 50 * (path.length).toDouble(), exit)
              ],
            )));
      }
    }

    return widgList;
  }

  switchVisible(String id) {
    setState(() {
      if (_scenarioVisibility[id] == true) {
        _scenarioVisibility[id] = false;
      } else {
        _scenarioVisibility[id] = true;
      }
    });
  }

  //----------------------------------------------------------------//
  //----------------------- Widget section -----------------------//
  //----------------------------------------------------------------//

  Widget addChoiceWidget(
      List<int> path, double margin, String choiceId, IconData icon) {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(margin + 5, 5, 5, 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 60,
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(icon),
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                  onPressed: () {
                    switchVisible(choiceId);
                  },
                ),
                Text("Choix i"),
              ]),
              Row(children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add_box),
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                  onPressed: () {
                    addChoice(path);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.mood_bad),
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                  onPressed: () {},
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.directions_run),
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                  onPressed: () {
                    addExit(path);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                  onPressed: () {
                    deleteChoice(path);
                  },
                ),
              ])
            ],
          )),
    ]);
  }

  Widget addTitleWidget(List<int> path, double margin, String title) {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(margin + 5, 5, 5, 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 60,
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.purple.shade300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Titre"),
              if (title == "")
                Text("A completer !",
                    style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold)),
              Row(children: [
                OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _PopupTitle(context, path, title),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                    child: Text("Modifier")),
              ])
            ],
          )),
    ]);
  }

  Widget addDescriptionWidget(
      List<int> path, double margin, String description) {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(margin + 5, 5, 5, 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 60,
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Description"),
              if (description == "")
                Text("A completer !",
                    style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold)),
              Row(children: [
                OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _PopupDescription(context, path, description),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                    child: Text("Modifier")),
              ])
            ],
          )),
    ]);
  }

  Widget addExitWidget(List<int> path, double margin, int level) {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(margin + 5, 5, 5, 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 60,
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.exit_to_app),
                Text("Sortie"),
              ]),
              Row(children: [
                Text("Niveau : "),
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _PopupLevel(context, path, level),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: Text(level.toString()),
                ),
              ])
            ],
          )),
    ]);
  }

  Widget addPicture() {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: 60,
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.blue.shade400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text("Image : "),
                if (_backroom["image"] != null)
                  Image.memory(base64.decode(_backroom["image"]), height: 50)
                else
                  Icon(Icons.image),
              ]),
              Row(children: [
                OutlinedButton(
                  onPressed: () {
                    _getFromGallery();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: Icon(Icons.add_a_photo),
                ),
              ])
            ],
          )),
    ]);
  }

  Widget addDifficulty() {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          height: 65,
          width: MediaQuery.of(context).size.width,
          child: Row(children: [
            Flexible(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.fromLTRB(5, 5, 2, 5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Difficultée : ",
                              style: TextStyle(color: Colors.black)),
                          OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _PopupDifficulty(context),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: Text("Select"),
                          ),
                        ]))),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.fromLTRB(2, 5, 5, 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.pink,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nb entitées : "),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _PopupEntityCount(context),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.teal,
                          ),
                          child: Text("Select"),
                        ),
                      ]),
                )),
          ]))
    ]);
  }

  Widget _PopupTitle(BuildContext context, List<int> path, String title) {
    TextEditingController _titleController = TextEditingController();
    _titleController.text = title;
    return AlertDialog(
      title: const Text('Titre'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red.shade400,
            ),
            child: Text("Annuler")),
        OutlinedButton(
            onPressed: () {
              modifTitle(path, _titleController.text);
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text("Valider")),
      ],
    );
  }

  Widget _PopupDescription(
      BuildContext context, List<int> path, String description) {
    TextEditingController _descriptionController = TextEditingController();
    _descriptionController.text = description;
    return AlertDialog(
      title: const Text('Description'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red.shade400,
            ),
            child: Text("Annuler")),
        OutlinedButton(
            onPressed: () {
              modifDescr(path, _descriptionController.text);
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text("Valider")),
      ],
    );
  }

  Widget _PopupLevel(BuildContext context, List<int> path, int level) {
    TextEditingController _levelController = TextEditingController();
    _levelController.text = level.toString();
    return AlertDialog(
      title: const Text('Niveau'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: _levelController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ]),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red.shade400,
            ),
            child: Text("Annuler")),
        OutlinedButton(
            onPressed: () {
              modifLevel(path, int.parse(_levelController.text));
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text("Valider")),
      ],
    );
  }

  Widget _PopupEntityCount(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre d\'entités'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlinedButton(
              onPressed: () {
                modifNbEntity("Minimale");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
              ),
              child: Text("Minimale")),
          OutlinedButton(
              onPressed: () {
                modifNbEntity("Normal");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.orange,
              ),
              child: Text("Normal")),
          OutlinedButton(
              onPressed: () {
                modifNbEntity("Beaucoups");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red.shade400,
              ),
              child: Text("Beaucoups")),
        ],
      ),
    );
  }

  Widget _PopupDifficulty(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre d\'entités'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlinedButton(
              onPressed: () {
                modifDifficulty("Sécurisé");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
              ),
              child: Text("Sécurisé")),
          OutlinedButton(
              onPressed: () {
                modifDifficulty("Dangereux");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.orange,
              ),
              child: Text("Dangereux")),
          OutlinedButton(
              onPressed: () {
                modifDifficulty("Mortel");
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red.shade400,
              ),
              child: Text("Mortel")),
        ],
      ),
    );
  }
}
