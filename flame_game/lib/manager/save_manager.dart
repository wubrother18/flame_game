import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/user_data.dart';

class SaveManager {
  late SharedPreferences prefs;

  SaveManager() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUserData(UserData userData) async {
    await prefs.setString('user_data', jsonEncode(userData.toJson()));
  }

  Future<UserData?> loadUserData() async {
    String? dataString = prefs.getString('user_data');
    if (dataString != null) {
      return UserData.fromJson(jsonDecode(dataString));
    }
    return null;
  }

  Future<void> clearUserData() async {
    await prefs.remove('user_data');
  }

  Future<void> saveGameState(Map<String, dynamic> state) async {
    await prefs.setString('game_state', jsonEncode(state));
  }

  Future<Map<String, dynamic>?> loadGameState() async {
    String? stateString = prefs.getString('game_state');
    if (stateString != null) {
      return jsonDecode(stateString);
    }
    return null;
  }

  Future<void> clearGameState() async {
    await prefs.remove('game_state');
  }
} 