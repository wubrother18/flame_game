import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/model/enums.dart';

part 'achievement_model.g.dart';

@JsonSerializable()
class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int maxProgress;
  final int expReward;
  final Map<String, int> itemRewards;
  final int tier;
  int currentProgress;
  bool claimed;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.maxProgress,
    required this.expReward,
    required this.itemRewards,
    required this.tier,
    required this.currentProgress,
    required this.claimed,
  });

  bool get isCompleted => currentProgress >= maxProgress;
  bool get canClaim => isCompleted && !claimed;
  double get progressPercentage => currentProgress / maxProgress;

  // 獲取成就圖標
  IconData? get categoryIcon {
    return switch (type) {
      AchievementType.collection => Icons.collections_bookmark,
      AchievementType.level => Icons.trending_up,
      AchievementType.event => Icons.event,
      AchievementType.popularity => Icons.favorite,
      AchievementType.creativity => Icons.lightbulb,
      AchievementType.professional => Icons.workspace_premium,
      AchievementType.writing => Icons.edit_note,
      AchievementType.login => Icons.calendar_today,
    };
  }

  // 獲取成就顏色
  MaterialColor? get categoryColor {
    return switch (type) {
      AchievementType.collection => Colors.purple,
      AchievementType.level => Colors.green,
      AchievementType.event => Colors.orange,
      AchievementType.popularity => Colors.red,
      AchievementType.creativity => Colors.yellow,
      AchievementType.professional => Colors.blue,
      AchievementType.writing => Colors.teal,
      AchievementType.login => Colors.indigo,
    };
  }

  // 獲取成就等級顏色
  Color get tierColor {
    return switch (tier) {
      1 => Colors.brown,
      2 => Colors.grey,
      3 => Colors.amber,
      _ => Colors.black,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == 'AchievementType.${json['type']}',
      ),
      maxProgress: json['maxProgress'] as int,
      expReward: json['expReward'] as int,
      itemRewards: Map<String, int>.from(json['itemRewards'] as Map),
      tier: json['tier'] as int,
      currentProgress: json['currentProgress'] as int,
      claimed: json['claimed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'maxProgress': maxProgress,
      'expReward': expReward,
      'itemRewards': itemRewards,
      'tier': tier,
      'currentProgress': currentProgress,
      'claimed': claimed,
    };
  }
} 