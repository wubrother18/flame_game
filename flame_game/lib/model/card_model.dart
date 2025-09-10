import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/model/enums.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import 'event_model.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'rank')
  final CardRank rank;
  @JsonKey(name: 'maxLevel')
  final int maxLevel;
  @JsonKey(name: 'connectionNumber')
  final int connectionNumber;
  @JsonKey(name: 'creativityBonus')
  final int creativityBonus;
  @JsonKey(name: 'popularityBonus')
  final int popularityBonus;
  @JsonKey(name: 'level')
  int level;
  @JsonKey(name: 'currentExp')
  int currentExp;
  @JsonKey(name: 'supportEvents')
  final List<GameEvent> supportEvents;
  @JsonKey(name: 'storyEvents')
  final List<GameEvent> storyEvents;
  @JsonKey(name: 'uniqueEvents')
  final List<GameEvent> uniqueEvents;
  @JsonKey(name: 'childList')
  final List<CardModel> childList;
  @JsonKey(name: 'collectedAt')
  DateTime? collectedAt;
  int breakthrough;
  int experience;
  final int maxBreakthrough;
  @JsonKey(name: 'image')
  final String image;
  @JsonKey(name: 'icon')
  final String icon;
  int baseHp;
  int baseMp;
  int basePoint;
  final int baseCreate;
  final int basePopular;

  // 添加 getter 以匹配預期的屬性名稱
  int get hpAdd => (baseHp * 0.1).toInt();
  int get mpAdd => (baseMp * 0.1).toInt();
  int get pointAdd => (basePoint * 0.1).toInt();
  int get createAdd => (baseCreate * 0.1).toInt();
  int get popularAdd => (basePopular * 0.1).toInt();
  int get connect => connectionNumber;
  int get requiredExperience => getRequiredExp();

  CardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rank,
    required this.image,
    required this.icon,
    this.level = 1,
    this.currentExp = 0,
    this.maxLevel = 20,
    this.creativityBonus = 0,
    this.popularityBonus = 0,
    this.connectionNumber = 0,
    this.breakthrough = 0,
    this.experience = 0,
    required this.supportEvents,
    required this.storyEvents,
    required this.uniqueEvents,
    required this.childList,
    this.collectedAt,
    required this.baseHp,
    required this.baseMp,
    required this.basePoint,
    required this.baseCreate,
    required this.basePopular,
  }) : maxBreakthrough = rank == CardRank.SSR ? 5 : 
       rank == CardRank.SR ? 4 : 
       rank == CardRank.R ? 3 : 2;

  int getRequiredExp() {
    return level * 100;
  }

  int get maxLevelWithBreakthrough {
    // 基礎等級上限
    final baseMaxLevel = switch (rank) {
      CardRank.N => 20,
      CardRank.R => 30,
      CardRank.SR => 40,
      CardRank.SSR => 50,
      CardRank.UR => 60,
      CardRank.L => 70,
    };
    // 每次突破增加20級
    return baseMaxLevel + breakthrough * 20;
  }

  bool canLevelUp(int exp) {
    if (level >= maxLevelWithBreakthrough) return false;
    return true;
  }

  int getMaxUsableExp() {
    if (level >= maxLevelWithBreakthrough) return 0;
    int remainingLevels = maxLevelWithBreakthrough - level;
    int totalExpNeeded = 0;
    int currentLevel = level;
    
    while (remainingLevels > 0) {
      totalExpNeeded += currentLevel * 100;
      currentLevel++;
      remainingLevels--;
    }
    
    return totalExpNeeded;
  }

  void addExperience(int exp) {
    if (level >= maxLevelWithBreakthrough) return;
    
    int remainingExp = exp;
    while (remainingExp >= getRequiredExp() && level < maxLevelWithBreakthrough) {
      remainingExp -= getRequiredExp();
      level++;
    }
    
    // 保存剩餘的經驗值
    currentExp = remainingExp;
  }

  // 計算突破所需材料
  Map<String, int> get breakthroughMaterials {
    final baseExp = 1000 * (breakthrough + 1);
    final baseGems = 100 * (breakthrough + 1);
    
    final multiplier = switch (rank) {
      CardRank.N => 1,
      CardRank.R => 2,
      CardRank.SR => 3,
      CardRank.SSR => 4,
      CardRank.UR => 5,
      CardRank.L => 1,
    };

    return {
      'exp': baseExp * multiplier,
      'gem': baseGems * multiplier,
    };
  }

  int getBreakthroughExpCost() {
    return breakthroughMaterials['exp'] ?? 0;
  }

  int getBreakthroughGemCost() {
    return breakthroughMaterials['gem'] ?? 0;
  }

  int getMaxExpForCurrentBreakthrough() {
    final baseExp = 1000 * (breakthrough + 1);
    return baseExp * switch (rank) {
      CardRank.N => 1,
      CardRank.R => 2,
      CardRank.SR => 3,
      CardRank.SSR => 4,
      CardRank.UR => 5,
      CardRank.L => 1,
    };
  }

  bool get canBreakthrough {
    if (breakthrough >= maxBreakthrough) return false;
    if (level < (breakthrough + 1) * 20) return false;
    return true;
  }

  // 計算當前屬性加成
  Map<String, int> get currentStats {
    double multiplier = 1 + (level - 1) * 0.1 + breakthrough * 0.2;
    return {
      'hp': (baseHp * multiplier).toInt(),
      'mp': (baseMp * multiplier).toInt(),
      'point': (basePoint * multiplier).toInt(),
      'create': (baseCreate * multiplier).toInt(),
      'popular': (basePopular * multiplier).toInt(),
    };
  }

  // 突破
  void breakthroughCard() {
    if (canBreakthrough) {
      breakthrough++;
    }
  }

  // 升級卡片
  bool upgrade() {
    if (level >= 5) return false;  // 最高等級為5
    level++;
    return true;
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rank: CardRank.values.firstWhere(
        (e) => e.toString() == 'CardRank.${json['rank']}',
      ),
      image: json['image'],
      icon: json['icon'],
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      maxLevel: json['maxLevel'] ?? 20,
      creativityBonus: json['creativityBonus'] ?? 0,
      popularityBonus: json['popularityBonus'] ?? 0,
      connectionNumber: json['connectionNumber'] ?? 0,
      breakthrough: json['breakthrough'] ?? 0,
      experience: json['experience'] ?? 0,
      supportEvents: (json['supportEvents'] as List<dynamic>?)
          ?.map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      storyEvents: (json['storyEvents'] as List<dynamic>?)
          ?.map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      uniqueEvents: (json['uniqueEvents'] as List<dynamic>?)
          ?.map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      childList: (json['childList'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      collectedAt: json['collectedAt'] != null
          ? DateTime.parse(json['collectedAt'] as String)
          : null,
      baseHp: json['baseHp'] as int? ?? 100,
      baseMp: json['baseMp'] as int? ?? 100,
      basePoint: json['basePoint'] as int? ?? 100,
      baseCreate: json['baseCreate'] as int? ?? 100,
      basePopular: json['basePopular'] as int? ?? 100,
    );
  }

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$CardModelToJson(this);

  bool get isCollected => collectedAt != null;

  Color get rarityColor {
    switch (rank.name.toLowerCase()) {
      case 'ssr':
        return Colors.amber;
      case 'sr':
        return Colors.purple;
      case 'r':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Map<String, int> getCurrentStats() {
    final multiplier = _getMultiplier();
    return {
      'hp': (baseHp * multiplier).round(),
      'mp': (baseMp * multiplier).round(),
      'point': (basePoint * multiplier).round(),
      'create': (baseCreate * multiplier).round(),
      'popular': (basePopular * multiplier).round(),
    };
  }

  double _getMultiplier() {
    return 1.0 + (level - 1) * 0.1;
  }

  @override
  String toString() {
    return 'CardModel{id: $id, name: $name, rank: $rank, level: $level}';
  }

  static int getMaxLevel(List<CardModel> cards) {
    if (cards.isEmpty) return 0;
    return cards.map((card) => card.level).reduce((a, b) => a > b ? a : b);
  }
}