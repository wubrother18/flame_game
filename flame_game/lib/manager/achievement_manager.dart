import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/card_data.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AchievementReward {
  final int exp;
  final Map<String, int> items;

  const AchievementReward({
    required this.exp,
    required this.items,
  });

  int get expReward => exp;
  Map<String, int> get itemRewards => items;
}

class AchievementManager {
  static AchievementManager? _instance;
  static AchievementManager get instance => _instance ??= AchievementManager._internal();
  
  final List<Achievement> _achievements = [];
  late SharedPreferences _prefs;
  Function(Achievement)? onAchievementCompleted;
  
  AchievementManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadAchievements();
  }

  Future<void> initialize() async {
    await init();
  }

  Future<void> _loadAchievements() async {
    final String? achievementsJson = _prefs.getString('achieve_data');
    if (achievementsJson != null) {
      final List<dynamic> list = jsonDecode(achievementsJson);
      _achievements.clear();
      _achievements.addAll(
        list.map((json) => Achievement.fromJson(json)).toList(),
      );
    } else {
      // 從 JSON 文件讀取成就數據
      await _loadAchievementsFromJson();
    }
  }

  Future<void> _loadAchievementsFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/achieve_data.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      
      _achievements.clear();
      for (var data in jsonData) {
        final achievement = Achievement(
          id: data['id'].toString(),
          name: data['name'],
          description: data['description'],
          type: AchievementType.values.firstWhere(
            (e) => e.toString() == 'AchievementType.${data['type']}',
            orElse: () => throw Exception('Invalid achievement type: ${data['type']}'),
          ),
          maxProgress: data['maxProgress'],
          expReward: data['expReward'],
          itemRewards: Map<String, int>.from(data['itemRewards']),
          tier: data['tier'],
          currentProgress: 0,
          claimed: false,
        );
        _achievements.add(achievement);
      }
      
      await _saveAchievements();
    } catch (e) {
      print('Error loading achievements from JSON: $e');
      // 如果讀取失敗，使用預設成就
      // _loadDefaultAchievements();
    }
  }

  void _loadDefaultAchievements() {
    _achievements.clear();
    _achievements.addAll([
      // 收藏成就
      Achievement(
        id: 'collection_1',
        name: '卡片收藏學徒',
        description: '收集1張不同的卡片',
        type: AchievementType.collection,
        maxProgress: 1,
        expReward: 100,
        itemRewards: {'gem': 10},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 等級成就
      Achievement(
        id: 'level_10',
        name: '見習玩家',
        description: '角色等級達到10級',
        type: AchievementType.level,
        maxProgress: 10,
        expReward: 1000,
        itemRewards: {'gem': 100},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 事件成就
      Achievement(
        id: 'event_1',
        name: '事件探索者',
        description: '完成1個事件',
        type: AchievementType.event,
        maxProgress: 1,
        expReward: 200,
        itemRewards: {'gem': 20},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 人氣成就
      Achievement(
        id: 'popularity_50',
        name: '人氣新星',
        description: '人氣達到50',
        type: AchievementType.popularity,
        maxProgress: 50,
        expReward: 500,
        itemRewards: {'gem': 50},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 創意成就
      Achievement(
        id: 'creativity_50',
        name: '創意萌芽',
        description: '創意達到50',
        type: AchievementType.creativity,
        maxProgress: 50,
        expReward: 500,
        itemRewards: {'gem': 50},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 專業度成就
      Achievement(
        id: 'professional_50',
        name: '專業學徒',
        description: '專業度達到50',
        type: AchievementType.professional,
        maxProgress: 50,
        expReward: 500,
        itemRewards: {'gem': 50},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
      // 寫作成就
      Achievement(
        id: 'writing_7',
        name: '寫作新星',
        description: '完成7天的寫作挑戰',
        type: AchievementType.writing,
        maxProgress: 7,
        expReward: 7000,
        itemRewards: {'gem': 700},
        tier: 1,
        currentProgress: 0,
        claimed: false,
      ),
    ]);
  }

  Future<void> _saveAchievements() async {
    final String achievementsJson = jsonEncode(
      _achievements.map((a) => a.toJson()).toList(),
    );
    await _prefs.setString('achieve_data', achievementsJson);
  }

  void add(Achievement achievement) {
    if (!_achievements.any((a) => a.id == achievement.id)) {
      _achievements.add(achievement);
      _saveAchievements();
    }
  }

  void del(String achievementId) {
    _achievements.removeWhere((a) => a.id == achievementId);
    _saveAchievements();
  }

  List<Achievement> getAchievements({AchievementType? type}) {
    if (type == null) {
      return List.from(_achievements);
    }
    return _achievements.where((a) => a.type == type).toList();
  }

  Future<void> updateProgress(AchievementType type, int id, int progress) async {
    final achievement = _achievements.firstWhere(
      (a) => a.type == type && a.id == "${type.name}_${id.toString()}",
      orElse: () => Achievement(
        id: id.toString(),
        name: _getAchievementName(type, id)??"",
        description: _getAchievementDescription(type, id)??"",
        type: type,
        maxProgress: id,
        expReward: _achievementConfigs[type]?[id]?.exp ?? 0,
        itemRewards: _achievementConfigs[type]?[id]?.items ?? {},
        tier: _getAchievementTier(id),
        currentProgress: 0,
        claimed: false,
      ),
    );

    if (!_achievements.contains(achievement)) {
      _achievements.add(achievement);
    }

    final oldProgress = achievement.currentProgress;
    achievement.currentProgress = progress;
    if (achievement.currentProgress > achievement.maxProgress) {
      achievement.currentProgress = achievement.maxProgress;
    }

    // 只有在進度增加且達到目標時才觸發成就完成事件
    if (achievement.currentProgress > oldProgress && 
        achievement.currentProgress >= achievement.maxProgress && 
        !achievement.claimed) {
      if (onAchievementCompleted != null) {
        onAchievementCompleted!(achievement);
      }
    }

    await _saveAchievements();
  }

  Future<AchievementReward> claimReward(AchievementType type, String id) async {
    final achievement = _achievements.firstWhere(
      (a) => a.type == type && a.id == id,
      orElse: () => Achievement(
        id: id.toString(),
        name: _getAchievementName(type, 0)??"",
        description: _getAchievementDescription(type, 0)??"",
        type: type,
        maxProgress: 0,
        expReward: _achievementConfigs[type]?[id]?.exp ?? 0,
        itemRewards: _achievementConfigs[type]?[id]?.items ?? {},
        tier: _getAchievementTier(0),
        currentProgress: 0,
        claimed: false,
      ),
    );

    if (achievement.canClaim) {
      achievement.claimed = true;
      await _saveAchievements();
      return AchievementReward(
        exp: achievement.expReward,
        items: achievement.itemRewards,
      );
    }

    return AchievementReward(exp: 0, items: {});
  }

  final Map<AchievementType, Map<int, AchievementReward>> _achievementConfigs = {
    AchievementType.collection: {
      1: AchievementReward(exp: 1000000000000000000, items: {'gem': 10000000000000000}),
      5: AchievementReward(exp: 500, items: {'gem': 50}),
      10: AchievementReward(exp: 1000, items: {'gem': 100}),
    },
    AchievementType.level: {
      10: AchievementReward(exp: 1000, items: {'gem': 100}),
      30: AchievementReward(exp: 3000, items: {'gem': 300}),
      50: AchievementReward(exp: 5000, items: {'gem': 500}),
    },
    AchievementType.event: {
      1: AchievementReward(exp: 200, items: {'gem': 20}),
      3: AchievementReward(exp: 600, items: {'gem': 60}),
      5: AchievementReward(exp: 1000, items: {'gem': 100}),
    },
    AchievementType.popularity: {
      50: AchievementReward(exp: 500, items: {'gem': 50}),
      100: AchievementReward(exp: 1000, items: {'gem': 100}),
      500: AchievementReward(exp: 5000, items: {'gem': 500}),
      1000: AchievementReward(exp: 10000, items: {'gem': 1000}),
      5000: AchievementReward(exp: 50000, items: {'gem': 5000}),
    },
    AchievementType.creativity: {
      50: AchievementReward(exp: 500, items: {'gem': 50}),
      100: AchievementReward(exp: 1000, items: {'gem': 100}),
      500: AchievementReward(exp: 5000, items: {'gem': 500}),
      1000: AchievementReward(exp: 10000, items: {'gem': 1000}),
      5000: AchievementReward(exp: 50000, items: {'gem': 5000}),
    },
    AchievementType.professional: {
      50: AchievementReward(exp: 500, items: {'gem': 50}),
      100: AchievementReward(exp: 1000, items: {'gem': 100}),
      500: AchievementReward(exp: 5000, items: {'gem': 500}),
      1000: AchievementReward(exp: 10000, items: {'gem': 1000}),
      5000: AchievementReward(exp: 50000, items: {'gem': 5000}),
    },
    AchievementType.writing: {
      7: AchievementReward(exp: 7000, items: {'gem': 700}),
      14: AchievementReward(exp: 14000, items: {'gem': 1400}),
      21: AchievementReward(exp: 21000, items: {'gem': 2100}),
      30: AchievementReward(exp: 30000, items: {'gem': 3000}),
    },
  };

  Future<List<Achievement>> getCompletedAchievements() async {
    return _achievements.where((a) => a.isCompleted && a.claimed).toList();
  }

  Future<List<Achievement>> getUncompletedAchievements() async {
    return _achievements.where((a) => !a.claimed).toList();
  }

  Future<bool> hasUncompletedAchievements() async {
    return _achievements.any((a) => !a.claimed && a.canClaim);
  }

  String? _getAchievementName(AchievementType type, int id) {
    return switch (type) {
      AchievementType.collection => '卡片收藏家',
      AchievementType.level => '成長達人',
      AchievementType.event => '事件專家',
      AchievementType.popularity => '人氣達人',
      AchievementType.creativity => '創意達人',
      AchievementType.professional => '專業達人',
      AchievementType.writing => '寫作達人',
      // TODO: Handle this case.
      AchievementType.login => null,
    };
  }

  String? _getAchievementDescription(AchievementType type, int id) {
    return switch (type) {
      AchievementType.collection => '收集 $id 張不同的卡片',
      AchievementType.level => '將任意卡片提升到 $id 級',
      AchievementType.event => '完成 $id 個事件',
      AchievementType.popularity => '人氣達到 $id',
      AchievementType.creativity => '創意達到 $id',
      AchievementType.professional => '專業度達到 $id',
      AchievementType.writing => '完成 $id 天的寫作挑戰',
      // TODO: Handle this case.
      AchievementType.login => null,
    };
  }

  int _getAchievementTier(int id) {
    if (id >= 5000) return 5;
    if (id >= 1000) return 4;
    if (id >= 500) return 3;
    if (id >= 100) return 2;
    return 1;
  }
} 