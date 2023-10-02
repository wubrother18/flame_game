import 'dart:convert';
import 'dart:math';

import 'package:flame_game/model/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticFunction {
  /// 單例
  static final StaticFunction self = StaticFunction();

  ///共用
  static late SharedPreferences prefs;


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




}