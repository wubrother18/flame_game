import 'package:json_annotation/json_annotation.dart';

import 'card_model.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  String id;
  String name;
  int gameLevel;
  String title;
  String type;
  List<CardModel> cards;
  List<String> childList;

  UserData(this.id, this.name, this.gameLevel, this.title, this.type,
      this.childList, this.cards);

  // 這個facotry是必須要有的，為了從map創建一個新的User實例
  // 把整個map傳遞`_$UserFromJson()`
  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}