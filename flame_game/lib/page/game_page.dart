import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game/main_screen.dart';
import '../model/card_model.dart';

class GamePage extends StatefulWidget {
  final List<CardModel> cardList;

  const GamePage({super.key, required this.cardList});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        GameWidget(game: MyGame()),
        Positioned(
            top: h * 5 / 16,
            left: w * 11 / 32,
            child: Container(
              width: 100,
              height: 150,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "固拉多",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("當前數值"),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("體力:20\n靈感:100\n專業:150"),
                  ),
                  Divider(
                    thickness: 3,
                  ),
                ],
              ),
            )),
        Positioned(
            top: h * 5 / 8 - 24,
            left: 10,
            right: 10,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(99))),
                    child: Row(
                      children: [],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(99))),
                  ),
                ],
              ),
            )),
        Positioned(
            top: h * 6 / 8,
            left: 10,
            right: 10,
            child: Container(
              color: Colors.transparent,
              width: 150,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 150,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(30, 255, 255, 255),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 178, 100)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(99))),
                      child: const Center(
                        child: Text(
                          "選擇一",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 150,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(30, 255, 255, 255),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 178, 100)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(99))),
                      child: const Center(
                        child: Text(
                          "選擇二",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          top: 32,
          right: w/3,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 50,
              height: 30,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(99))),
              child: const Center(
                child: Text(
                  "離開",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
