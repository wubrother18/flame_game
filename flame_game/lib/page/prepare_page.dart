import 'package:flame_game/page/game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreparePage extends StatefulWidget {
  const PreparePage({super.key});

  @override
  State<PreparePage> createState() => _PreparePageState();
}

class _PreparePageState extends State<PreparePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 51, 10, 112),
                Color.fromARGB(255, 47, 16, 207),
              ]),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(99))),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 375,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Container(
                          height: 200,
                          width: 150,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromARGB(30, 255, 255, 255)),
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.black,
                                ),
                              ),
                              Positioned(
                                  top: 150,
                                  right: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 100, 100, 100),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(99))),
                                      child: const Center(
                                        child: Text(
                                          "變更",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: const Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text("名稱"),
                              ),
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
                                child: Text("角色資訊"),
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
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 178, 100),
                          borderRadius: BorderRadius.all(Radius.circular(99))),
                      child: const Center(
                        child: Text(
                          "夥伴卡",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: double.infinity,
                        height: 350,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(200, 255, 255, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 1.0),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                              );
                            })),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        gotoGame();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(30, 255, 255, 255),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 255, 178, 100)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(99))),
                        child: const Center(
                          child: Text(
                            "煉成",
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  gotoGame() {
    Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const GamePage(cardList: []),
                fullscreenDialog: true))
        .then((value) {});
  }
}
