import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  final double titleSize1 = 35;
  final double paragraphe = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          width: double.maxFinite,
          color: Colors.grey.shade800,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contextSection(),
            ],
          ),
        )),
      ),
    );
  }

  Widget contextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title1("Histoire"),
        space(10),
        divider(),
        space(20),
        Text(
          "Après une des journées les plus rudes de votre vie, vous vous empressez de rentrer chez vous et de fermer votre porte à clef. Pris d'une colère incontrôlable vous tapez sur un des murs de votre salon, fermant les yeux et en criant de toutes vos forces. C'est après de nombreuses minutes que vous vous calmez enfin et réouvrez les yeux. C'est alors que vous remarquez que vous être dans un endroit inconnu mais familier, sans bruits, sans personnes.... \n \n"
          "Vous vous demandez sûrement ou vous êtes et je vais vous expliquer. Il arrive parfois que des personnes, par diverses moyens, se détachent de la réalité et se retrouvent dans cette dimension. Mais ne paniquez pas, il est possible d'y sortir. Pour cela il faut vous enfoncer dans les backrooms, si possibles accompagne, afin de tenter de s'échapper.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: paragraphe),
        ),
        space(50),
        title1("Backroom"),
        space(10),
        divider(),
        space(20),
        Text(
          "Les backrooms sont un enchainement de pièces non symétriques et disposées de manière aléatoire formant un labyrinthe.\n"
          "Par simplification, les backrooms sont nommées en différents niveaux pouvant contenir des objets mais aussi des entités qui peuvent être pacifiques et ignorantes mais d'autres sont à ne pas croisées et sont particulièrement dangereuses.\n \n"
          "Retrouvez les notes de tout les voyageurs en cliquant sur ce lien :",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: paragraphe),
        ),
        InkWell(
          child: Text(
            'backrooms-wiki.wikidot.com',
            style: TextStyle(fontSize: paragraphe, color: Colors.blue.shade400),
          ),
          onTap: () async {
            {
              if (!await launch('http://backrooms-wiki.wikidot.com/')) {
                throw 'Could not launch link';
              }
            }
          },
        ),
      ],
    );
  }

  Widget divider() {
    return Container(
      width: double.infinity,
      height: 5,
      color: Colors.grey.shade400,
    );
  }

  Widget title1(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: titleSize1, fontFamily: "Exquisite-Corpse"),
    );
  }

  Widget space(double size) {
    return SizedBox(height: size);
  }
}
