import 'package:flame/game.dart';
import 'package:flame_game/manager/game_manager.dart';
import 'package:flame_game/model/example_card.dart';
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
  GameManager? gameManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameManager = GameManager.ins();
    gameManager?.init([
      ExampleCard().getCard(),
      ExampleCard().getCard(),
      ExampleCard().getCard(),
      ExampleCard().getCard(),
      ExampleCard().getCard(),
      ExampleCard().getCard(),
    ]);
  }

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
            left: 100,
            right: 100,
            child: Container(
              width: 100,
              height: 120,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${gameManager?.role?.name}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("當前數值"),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("體力:${gameManager?.role?.hp} 靈感:${gameManager?.role?.mp} 專業:${gameManager?.role?.point}"),
                  ),
                  const Divider(
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
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(99))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${gameManager?.days}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "天數",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                                strutStyle: StrutStyle(forceStrutHeight: true),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(4),
                          height: 52,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${gameManager?.create}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "創意",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                                strutStyle: StrutStyle(forceStrutHeight: true),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(4),
                          height: 52,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${gameManager?.point}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "專業",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                                strutStyle: StrutStyle(forceStrutHeight: true),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(4),
                          height: 52,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${gameManager?.popular}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "人氣",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                  fontFamilyFallback: <String>[
                                    'Noto Sans TC',
                                  ],
                                ),
                                strutStyle: StrutStyle(forceStrutHeight: true),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ],
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
                    child: const Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "F",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lato',
                              fontFamilyFallback: <String>[
                                'Noto Sans TC',
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "總評價",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lato',
                              fontFamilyFallback: <String>[
                                'Noto Sans TC',
                              ],
                            ),
                            strutStyle: StrutStyle(forceStrutHeight: true),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
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
                  for(int i=0;i<gameManager!.eventHelper!.eventList.length;i++)
                  TextButton(
                    onPressed: () {
                      gameManager!.role?.getEvent(gameManager!.eventHelper!.eventList[i]);
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text(gameManager!.eventHelper!.eventList[i]!.title!),
                              content: Text(gameManager!.eventHelper!.eventList[i]!.describe!),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                    setState(() {

                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    child: Container(
                      width: 150,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(30, 255, 255, 255),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 178, 100)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(99))),
                      child: Center(
                        child: Text(
                          gameManager!.eventHelper!.eventList[i]!.title!,
                          style: const TextStyle(
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
          right: 32,
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
