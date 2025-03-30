import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/card_data.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'dart:convert';

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
    final String? achievementsJson = _prefs.getString('achievements');
    if (achievementsJson != null) {
      final List<dynamic> list = jsonDecode(achievementsJson);
      _achievements.clear();
      _achievements.addAll(
        list.map((json) => Achievement.fromJson(json)).toList(),
      );
    }
  }

  Future<void> _saveAchievements() async {
    final String achievementsJson = jsonEncode(
      _achievements.map((a) => a.toJson()).toList(),
    );
    await _prefs.setString('achievements', achievementsJson);
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
      (a) => a.type == type && a.id == id.toString(),
      orElse: () => Achievement(
        id: id.toString(),
        name: _getAchievementName(type, id),
        description: _getAchievementDescription(type, id),
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

    achievement.currentProgress = progress;
    if (achievement.currentProgress > achievement.maxProgress) {
      achievement.currentProgress = achievement.maxProgress;
    }
    await _saveAchievements();
  }

  Future<AchievementReward> claimReward(AchievementType type, int id) async {
    final achievement = _achievements.firstWhere(
      (a) => a.type == type && a.id == id.toString(),
      orElse: () => Achievement(
        id: id.toString(),
        name: _getAchievementName(type, id),
        description: _getAchievementDescription(type, id),
        type: type,
        maxProgress: id,
        expReward: _achievementConfigs[type]?[id]?.exp ?? 0,
        itemRewards: _achievementConfigs[type]?[id]?.items ?? {},
        tier: _getAchievementTier(id),
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
      1: AchievementReward(exp: 100, items: {'gem': 10}),
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

  String _getAchievementName(AchievementType type, int id) {
    return switch (type) {
      AchievementType.collection => '卡片收藏家',
      AchievementType.level => '成長達人',
      AchievementType.event => '事件專家',
      AchievementType.special => '特殊成就',
    };
  }

  String _getAchievementDescription(AchievementType type, int id) {
    return switch (type) {
      AchievementType.collection => '收集 $id 張不同的卡片',
      AchievementType.level => '將任意卡片提升到 $id 級',
      AchievementType.event => '完成 $id 個事件',
      AchievementType.special => '完成特殊成就 #$id',
    };
  }

  int _getAchievementTier(int id) {
    if (id >= 50) return 3;
    if (id >= 20) return 2;
    return 1;
  }
} 