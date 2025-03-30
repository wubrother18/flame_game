// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      maxProgress: json['maxProgress'] as int,
      expReward: json['expReward'] as int,
      itemRewards: Map<String, int>.from(json['itemRewards'] as Map),
      tier: json['tier'] as int,
      currentProgress: json['currentProgress'] as int,
      claimed: json['claimed'] as bool,
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'maxProgress': instance.maxProgress,
      'expReward': instance.expReward,
      'itemRewards': instance.itemRewards,
      'tier': instance.tier,
      'currentProgress': instance.currentProgress,
      'claimed': instance.claimed,
    };

const _$AchievementTypeEnumMap = {
  AchievementType.collection: 'collection',
  AchievementType.level: 'level',
  AchievementType.event: 'event',
  AchievementType.special: 'special',
};
