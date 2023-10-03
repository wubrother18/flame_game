// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEvent _$GameEventFromJson(Map<String, dynamic> json) => GameEvent(
      json['title'] as String?,
      json['mpEffect'] as int?,
      json['hpEffect'] as int?,
      json['pointEffect'] as int?,
      json['randomAble'] as bool?,
      json['hasAnimate'] as bool?,
      json['describe'] as String?,
    );

Map<String, dynamic> _$GameEventToJson(GameEvent instance) => <String, dynamic>{
      'title': instance.title,
      'mpEffect': instance.mpEffect,
      'hpEffect': instance.hpEffect,
      'pointEffect': instance.pointEffect,
      'randomAble': instance.randomAble,
      'hasAnimate': instance.hasAnimate,
      'describe': instance.describe,
    };
