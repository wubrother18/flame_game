// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      json['id'] as String,
      json['name'] as String,
      json['gameLevel'] as int,
      json['title'] as String,
      json['type'] as String,
      (json['childList'] as List<dynamic>).map((e) => e as String).toList(),
      (json['cards'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gameLevel': instance.gameLevel,
      'title': instance.title,
      'type': instance.type,
      'cards': instance.cards,
      'childList': instance.childList,
    };
