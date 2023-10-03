import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game/main_screen.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children: [
        GameWidget(game: MyGame()),

      ]),
    );
  }
}
