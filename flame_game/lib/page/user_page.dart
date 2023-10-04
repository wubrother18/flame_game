import 'package:flame_game/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/user_data.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController textEditingController = TextEditingController();

  String? name;
  int level = 1;
  String? title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserData? userData = StaticFunction.getInstance().getAccount();
    name = userData?.name;
    level = userData?.gameLevel ?? 1;
    title = userData?.title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: h,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 237, 229, 160),
              Color.fromARGB(255, 255, 235, 57)
            ])),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Colors.black,
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
                        SizedBox(
                          width: 24,
                        ),
                        Container(
                          height: 200,
                          width: 150,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromARGB(30, 255, 255, 255)),
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("名稱"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color.fromARGB(100, 255, 255, 255)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(name ?? ""),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "更改名稱",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              content: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                  border: Border.all(color: Colors.black)
                                                ),
                                                child: EditableText(
                                                  controller:
                                                  textEditingController,
                                                  focusNode: FocusNode(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w400),
                                                  cursorColor: Colors.black,
                                                  backgroundCursorColor:
                                                  Colors.black,
                                                ),
                                              ),
                                              actions: [
                                                MaterialButton(
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      UserData? user = StaticFunction.getInstance().getAccount();
                                                      user?.name = textEditingController.text;
                                                      StaticFunction.getInstance().editAccount(user!);
                                                      name = textEditingController.text;
                                                      Navigator.pop(context);
                                                      setState(() {

                                                      });
                                                    },
                                                    child: const Text(
                                                      "確定",
                                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                                    )),
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(Icons.edit,
                                        size: 24, color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("等級"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color.fromARGB(100, 255, 255, 255)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("$level"),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("稱號"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color.fromARGB(100, 255, 255, 255)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(title ?? ""),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      width: 320,
                      height: 320,
                      child: QrImageView(
                        data: 'This is a simple QR code',
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
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
}
