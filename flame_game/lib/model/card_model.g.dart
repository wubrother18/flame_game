// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rank: $enumDecode(_$CardRankEnumMap, json['rank']),
      image: json['image'] as String,
      level: json['level'] as int? ?? 1,
      currentExp: json['currentExp'] as int? ?? 0,
      maxLevel: json['maxLevel'] as int? ?? 10,
      hpBonus: json['hpBonus'] as int? ?? 0,
      mpBonus: json['mpBonus'] as int? ?? 0,
      pointsBonus: json['pointsBonus'] as int? ?? 0,
      creativityBonus: json['creativityBonus'] as int? ?? 0,
      popularityBonus: json['popularityBonus'] as int? ?? 0,
      connectionNumber: json['connectionNumber'] as int? ?? 0,
      breakthrough: json['breakthrough'] as int? ?? 0,
      experience: json['experience'] as int? ?? 0,
      supportEvents: (json['supportEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      storyEvents: (json['storyEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      uniqueEvents: (json['uniqueEvents'] as List<dynamic>)
          .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      childList: (json['childList'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      collectedAt: json['collectedAt'] == null
          ? null
          : DateTime.parse(json['collectedAt'] as String),
      baseHp: json['baseHp'] as int,
      baseMp: json['baseMp'] as int,
      basePoint: json['basePoint'] as int,
      baseCreate: json['baseCreate'] as int,
      basePopular: json['basePopular'] as int,
    );

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'rank': _$CardRankEnumMap[instance.rank]!,
      'maxLevel': instance.maxLevel,
      'connectionNumber': instance.connectionNumber,
      'hpBonus': instance.hpBonus,
      'mpBonus': instance.mpBonus,
      'pointsBonus': instance.pointsBonus,
      'creativityBonus': instance.creativityBonus,
      'popularityBonus': instance.popularityBonus,
      'level': instance.level,
      'currentExp': instance.currentExp,
      'supportEvents': instance.supportEvents,
      'storyEvents': instance.storyEvents,
      'uniqueEvents': instance.uniqueEvents,
      'childList': instance.childList,
      'collectedAt': instance.collectedAt?.toIso8601String(),
      'breakthrough': instance.breakthrough,
      'experience': instance.experience,
      'image': instance.image,
      'baseHp': instance.baseHp,
      'baseMp': instance.baseMp,
      'basePoint': instance.basePoint,
      'baseCreate': instance.baseCreate,
      'basePopular': instance.basePopular,
    };

const _$CardRankEnumMap = {
  CardRank.N: 'N',
  CardRank.R: 'R',
  CardRank.SR: 'SR',
  CardRank.SSR: 'SSR',
};
