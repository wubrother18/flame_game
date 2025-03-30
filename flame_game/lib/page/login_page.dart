import 'package:flame_game/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

import '../dialog.dart';
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
              Color.fromARGB(255,51, 10, 112),
              Color.fromARGB(255, 47, 16, 207),
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
              width: 10,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 255, 178, 19), offset: Offset(0, 5), blurRadius: 80)
              ]),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                " 30 天煉成",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 178, 19),
                    fontSize: 48,
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

  Future<void> checkToLogin() async {
    ///check has data
    if (StaticFunction.instance.getAccount() == null) {
      await showDialog(context: context, builder: (context){
        return DialogHelper.showWarning(context, "遊客帳號", "將以遊客帳號登入遊戲，若遊戲被刪除，資料也會無法復原。請盡快綁定您的帳號", "知道了", (){
          Navigator.pop(context);
        });
      });
      await StaticFunction.instance.createAccount();
    }else{

    }
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MainPage(), fullscreenDialog: true))
        .then((value) {});
  }
}
