// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
      json['name'] as String,
      json['rank'] as int,
      json['level'] as int,
      json['connect'] as int,
      json['hpAdd'] as int,
      json['mpAdd'] as int,
      json['pointAdd'] as int,
      (json['supportEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['storyEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['uniqueEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
      'name': instance.name,
      'rank': instance.rank,
      'level': instance.level,
      'connect': instance.connect,
      'hpAdd': instance.hpAdd,
      'mpAdd': instance.mpAdd,
      'pointAdd': instance.pointAdd,
      'supportEvents': instance.supportEvents,
      'storyEvents': instance.storyEvents,
      'uniqueEvents': instance.uniqueEvents,
    };
