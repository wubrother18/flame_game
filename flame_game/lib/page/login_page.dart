import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 156, 89, 254),
              Color.fromARGB(255, 111, 83, 253)
            ]),
      ),
      child: ClipRect(
          child: Stack(
        children: [
          CircularParticle(
            onTapAnimation: false,
            numberOfParticles: 200,
            speedOfParticles: -1,
            height: h,
            width: w,
            maxParticleSize: 1,
            isRandSize: true,
            isRandomColor: true,
            randColorList: const [Colors.white],
            awayAnimationCurve: Curves.easeInCubic,
            connectDots: false,
          ),
          Positioned(
            top: h / 3,
            right: w / 8,
            left: w / 8,
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.indigo, offset: Offset(0, 20), blurRadius: 30)
              ]),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                " 30 天煉成 ",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto'),
              ),
            ),
          ),),
          Positioned(
              top: h * 2 / 3,
              right: w / 8,
              left: w / 8,
              child: SizedBox(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(100, 249, 249, 251)),
                  ),
                  onPressed: () {
                    checkToLogin();
                  },
                  child: const Text(
                    "進入遊戲",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ))
        ],
      )),
    ));
  }

  void checkToLogin() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainPage(), fullscreenDialog: true))
        .then((value) {});
  }
}
