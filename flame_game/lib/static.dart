import 'dart:convert';
import 'dart:math';

import 'package:flame_game/manager/achieve_manager.dart';
import 'package:flame_game/model/user_data.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:flame_game/manager/event_helper.dart';
import 'package:flame_game/manager/game_manager.dart';
import 'package:flame_game/manager/role_manager.dart';
import 'package:flame_game/manager/save_manager.dart';
import 'package:flame_game/manager/shop_manager.dart';
import 'package:flame_game/manager/task_manager.dart';
import 'package:flame_game/manager/upgrade_manager.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'package:flame_game/manager/gacha_manager.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'package:flame_game/model/enums.dart';

class StaticFunction {
  static final StaticFunction _instance = StaticFunction._internal();
  static StaticFunction get instance => _instance;
  static late SharedPreferences prefs;

  late final AchievementManager _achievementManager;
  AchievementManager get achieveManager => _achievementManager;
  late final CardManager cardManager;
  late final RoleManager roleManager;
  late final GachaManager gachaManager;
  late final GameManager gameManager;
  late EventHelper eventHelper;
  late SaveManager saveManager;
  late ShopManager shopManager;
  late TaskManager taskManager;
  late UpgradeManager upgradeManager;

  StaticFunction._internal() {
    _achievementManager = AchievementManager.instance;
    cardManager = CardManager.instance;
    roleManager = RoleManager.instance;
    gachaManager = GachaManager.instance;
    gameManager = GameManager.ins();
    eventHelper = EventHelper();
    saveManager = SaveManager();
    shopManager = ShopManager();
    taskManager = TaskManager();
    upgradeManager = UpgradeManager();
  }

  Future<void> init() async {
    await _achievementManager.initialize();
    await cardManager.init();
    await gachaManager.init();
    await gameManager.start();
  }

  Future<void> createAccount() async {
    int id = DateTime.now().microsecondsSinceEpoch;
    int gameLevel = 1;
    String name = "新人";
    UserData userData = UserData(id.toString(), name, gameLevel, "", "", [], []);
    await prefs.setString("user_data", jsonEncode(userData.toJson()));
  }

  UserData? getAccount() {
    String? dataString = prefs.getString("user_data");
    print(dataString);
    _achievementManager.add(Achievement(
      id: "login_times",
      name: "登入次數",
      description: "登入遊戲",
      type: AchievementType.special,
      maxProgress: 1,
      expReward: 100,
      itemRewards: {},
      tier: 1,
      currentProgress: 1,
      claimed: false,
    ));
    return dataString != null ? UserData.fromJson(jsonDecode(dataString)) : null;
  }

  Future<UserData?> editAccount(UserData userData) async {
    await prefs.setString("user_data", jsonEncode(userData.toJson()));
    String? dataString = prefs.getString("user_data");
    UserData userDataNew = UserData.fromJson(jsonDecode(dataString!));
    return userDataNew;
  }

  Future<void> checkAchieveListBuild() async {
    final achievements = await _achievementManager.getAchievements();
    String? dataString = prefs.getString("achieve_data");
    if (dataString == null) {
      dataString = await rootBundle.loadString('assets/data/achieve_data.json');
      await prefs.setString("achieve_data", dataString);
    }
    print("成就列表 : $dataString");
  }
}