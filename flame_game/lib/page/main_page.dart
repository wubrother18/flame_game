import 'package:flame/game.dart';
import 'package:flame_game/game/main_screen.dart';
import 'package:flame_game/page/prepare_page.dart';
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
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                        CupertinoPageRoute(
                                builder: (context) => const UserPage()))
                        .then((value) {});
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(99))),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 500,
              right: 24,
              child: GestureDetector(
                onTap: () {

                  Navigator.push(
                          context,
                      CupertinoPageRoute(
                              builder: (context) => const PreparePage()))
                      .then((value) {});
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 150,
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 178, 19),
                          width: 5),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 237, 229, 160),
                        Color.fromARGB(255, 255, 235, 57)
                      ])),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "煉成",
                      style: TextStyle(
                          color: Color.fromARGB(255, 200, 100, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
