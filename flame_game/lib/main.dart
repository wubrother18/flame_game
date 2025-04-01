import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame_game/manager/notification.dart';
import 'package:flame_game/page/prepare_page.dart';
import 'package:flame_game/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/manager/game_manager.dart';
import 'package:flame_game/manager/gacha_manager.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/page/home_page.dart';
import 'package:flame_game/page/card_collection_page.dart';
import 'package:flame_game/page/achievement_page.dart';
import 'package:flame_game/page/game_page.dart';
import 'package:flame_game/page/result_page.dart';
import 'package:flame_game/page/gacha_page.dart';
import 'package:flame_game/page/card_growth_page.dart';
import 'package:flame_game/page/test_page.dart';
import 'package:flame_game/page/card_detail_page.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/theme/app_theme.dart';

Future<void> main() async {
  ///連結硬體
  WidgetsFlutterBinding.ensureInitialized();
  ///設為全螢幕
  Flame.device.fullScreen();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  StaticFunction.prefs = prefs;
  await StaticFunction.instance.init();
  await StaticFunction.instance.checkAchieveListBuild();
  await GachaManager.instance.init();
  await CardManager.instance.init();

  LocalNotificationService.initialize();

  await GameManager.ins().start();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '30 days Achieve',
      theme: AppTheme.lightTheme,
      builder: (BuildContext? context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context!);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/prepare': (context) => const PreparePage(),
        '/collection': (context) => const CardCollectionPage(),
        '/achievement': (context) => const AchievementPage(),
        '/game': (context) => GamePage(
          selectedCards: ModalRoute.of(context)!.settings.arguments as List<CardModel>,
        ),
        '/result': (context) => ResultPage(result: {}), // TODO: Pass actual result
        '/gacha': (context) => const GachaPage(),
        '/growth': (context) => CardGrowthPage(
          card: ModalRoute.of(context)!.settings.arguments as CardModel,
        ),
        '/card_detail': (context) => CardDetailPage(
          card: ModalRoute.of(context)!.settings.arguments as CardModel,
        ),
        '/test': (context) => const TestPage(),
      },
    );
  }
}


