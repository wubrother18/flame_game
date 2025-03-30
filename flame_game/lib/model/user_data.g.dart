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
      currentHp: json['currentHp'] as int? ?? 100,
      currentMp: json['currentMp'] as int? ?? 50,
      point: json['point'] as int? ?? 0,
      create: json['create'] as int? ?? 0,
      popular: json['popular'] as int? ?? 0,
      daysPlayed: json['daysPlayed'] as int? ?? 0,
      eventsCompleted: json['eventsCompleted'] as int? ?? 0,
      upgrades: (json['upgrades'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      inventory: (json['inventory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      completedAchievements: (json['completedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentCardId: json['currentCardId'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gameLevel': instance.gameLevel,
      'title': instance.title,
      'type': instance.type,
      'cards': instance.cards,
      'childList': instance.childList,
      'currentHp': instance.currentHp,
      'currentMp': instance.currentMp,
      'point': instance.point,
      'create': instance.create,
      'popular': instance.popular,
      'daysPlayed': instance.daysPlayed,
      'eventsCompleted': instance.eventsCompleted,
      'upgrades': instance.upgrades,
      'inventory': instance.inventory,
      'completedAchievements': instance.completedAchievements,
      'currentCardId': instance.currentCardId,
    };
