import 'package:flame/game.dart';
import 'package:flame_game/game/main_screen.dart';
import 'package:flame_game/page/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: MyGame()),
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.blueAccent
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserPage(), fullscreenDialog: true))
                        .then((value) {});
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(99))
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}