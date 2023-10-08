import 'dart:convert';
import 'dart:math';

import 'package:flame_game/manager/achieve_manager.dart';
import 'package:flame_game/model/user_data.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticFunction {
  /// 單例
  static final StaticFunction self = StaticFunction();

  ///共用
  static late SharedPreferences prefs;

  AchieveManager achieveManager = AchieveManager.getInstance();


  static StaticFunction getInstance() {
    return self;
  }

  Future<void> createAccount () async {

    int id = DateTime.now().microsecondsSinceEpoch;
    int gameLevel = 1;
    String name = "新人";
    UserData userData = UserData(id.toString(), name, gameLevel, "", "", [], []);
    await prefs.setString("user_data",jsonEncode(userData.toJson()));
  }

  UserData? getAccount ()  {
    String? dataString = prefs.getString("user_data");
    print(dataString);
    achieveManager.add({"login_times":1});
    return dataString != null ? UserData.fromJson(jsonDecode(dataString)) : null;
  }

  Future<UserData?> editAccount (UserData userData)  async {
    /// input
    await prefs.setString("user_data",jsonEncode(userData.toJson()));

    /// output to check again
    String? dataString = prefs.getString("user_data");
    UserData userDataNew = UserData.fromJson(jsonDecode(dataString!));
    return userDataNew;
  }

  checkAchieveListBuild() async {
    String? dataString = prefs.getString("achieve_data");
    if(dataString == null){
      dataString = await rootBundle.loadString('assets/data/achieve_data.json');
      await prefs.setString("achieve_data",dataString);
    }
    print("成就列表 : $dataString");
  }






}