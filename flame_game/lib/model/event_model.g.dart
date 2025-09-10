// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEvent _$GameEventFromJson(Map<String, dynamic> json) => GameEvent(
      title: json['title'] as String,
      description: json['description'] as String,
      mpEffect: (json['mpEffect'] as num).toInt(),
      hpEffect: (json['hpEffect'] as num).toInt(),
      pointEffect: (json['pointEffect'] as num).toInt(),
      createEffect: (json['createEffect'] as num?)?.toInt() ?? 0,
      popularEffect: (json['popularEffect'] as num?)?.toInt() ?? 0,
      professionalEffect: (json['professionalEffect'] as num?)?.toInt() ?? 0,
      randomAble: json['randomAble'] as bool,
    );

Map<String, dynamic> _$GameEventToJson(GameEvent instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'mpEffect': instance.mpEffect,
      'hpEffect': instance.hpEffect,
      'pointEffect': instance.pointEffect,
      'createEffect': instance.createEffect,
      'popularEffect': instance.popularEffect,
      'professionalEffect': instance.professionalEffect,
      'randomAble': instance.randomAble,
    };
