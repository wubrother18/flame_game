import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as g;
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame_game/page/login_page.dart';
import 'package:flame_game/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

Future<void> main() async {
  ///連結硬體
  WidgetsFlutterBinding.ensureInitialized();
  ///設為全螢幕
  Flame.device.fullScreen();
  var defaultHome = const LoginPage();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '30 days Achieve',
      theme: ThemeData(
      ),
      builder: (BuildContext? context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context!);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      home:defaultHome)));
}


