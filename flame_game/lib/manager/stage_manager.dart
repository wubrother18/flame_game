import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/card_data.dart';

import '../service/card_config_service.dart';
// 關卡類型
enum StageType {
  tutorial,    // 教學關卡
  daily,       // 每日關卡
  weekly,      // 週常關卡
  event,       // 活動關卡
  challenge    // 挑戰關卡
}

// 關卡獎勵
class StageReward {
  final List<CardModel> guaranteedCards;  // 保底卡片
  final double cardDropRate;              // 卡片掉落率
  final Map<String, int> resources;       // 資源獎勵

  StageReward({
    required this.guaranteedCards,
    required this.cardDropRate,
    required this.resources,
  });
}

class StageManager {
  static final StageManager instance = StageManager._internal();
  StageManager._internal();


  // 關卡配置
  final Map<StageType, Map<int, StageReward>> _stageConfigs = {
    StageType.tutorial: {
      1: StageReward(
        guaranteedCards: [CardConfigService.instance.getAllCards()[0]],
        cardDropRate: 1.0,
        resources: {'point': 100, 'create': 50, 'popular': 30},
      ),
      2: StageReward(
        guaranteedCards: [CardConfigService.instance.getAllCards()[1]],
        cardDropRate: 1.0,
        resources: {'point': 100, 'create': 50, 'popular': 30},
      ),
      3: StageReward(
        guaranteedCards: [CardConfigService.instance.getAllCards()[2]],
        cardDropRate: 1.0,
        resources: {'point': 100, 'create': 50, 'popular': 30},
      ),
    },
    StageType.daily: {
      1: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.1,
        resources: {'point': 50, 'create': 30, 'popular': 20},
      ),
      2: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.15,
        resources: {'point': 75, 'create': 45, 'popular': 30},
      ),
      3: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.2,
        resources: {'point': 100, 'create': 60, 'popular': 40},
      ),
    },
    StageType.weekly: {
      1: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.3,
        resources: {'point': 200, 'create': 120, 'popular': 80},
      ),
      2: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.4,
        resources: {'point': 300, 'create': 180, 'popular': 120},
      ),
      3: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.5,
        resources: {'point': 400, 'create': 240, 'popular': 160},
      ),
    },
    StageType.event: {
      1: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.4,
        resources: {'point': 300, 'create': 180, 'popular': 120},
      ),
      2: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.5,
        resources: {'point': 400, 'create': 240, 'popular': 160},
      ),
      3: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.6,
        resources: {'point': 500, 'create': 300, 'popular': 200},
      ),
    },
    StageType.challenge: {
      1: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.5,
        resources: {'point': 500, 'create': 300, 'popular': 200},
      ),
      2: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.6,
        resources: {'point': 600, 'create': 360, 'popular': 240},
      ),
      3: StageReward(
        guaranteedCards: [],
        cardDropRate: 0.7,
        resources: {'point': 700, 'create': 420, 'popular': 280},
      ),
    },
  };

  // 獲取關卡獎勵
  StageReward getStageReward(StageType type, int stageId) {
    return _stageConfigs[type]?[stageId] ?? StageReward(
      guaranteedCards: [],
      cardDropRate: 0.0,
      resources: {},
    );
  }

  // 檢查關卡是否解鎖
  Future<bool> isStageUnlocked(StageType type, int stageId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'stage_${type.toString()}_$stageId';
    return prefs.getBool(key) ?? false;
  }

  // 解鎖關卡
  Future<void> unlockStage(StageType type, int stageId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'stage_${type.toString()}_$stageId';
    await prefs.setBool(key, true);
  }

  // 獲取關卡進度
  Future<int> getStageProgress(StageType type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'stage_progress_${type.toString()}';
    return prefs.getInt(key) ?? 0;
  }

  // 更新關卡進度
  Future<void> updateStageProgress(StageType type, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'stage_progress_${type.toString()}';
    await prefs.setInt(key, progress);
  }

  // 重置每日關卡
  Future<void> resetDailyStages() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'daily_stage_reset';
    final lastReset = DateTime.parse(prefs.getString(key) ?? DateTime.now().toIso8601String());
    final now = DateTime.now();

    if (lastReset.day != now.day) {
      await prefs.setString(key, now.toIso8601String());
      await prefs.setInt('stage_progress_${StageType.daily.toString()}', 0);
    }
  }

  // 重置週常關卡
  Future<void> resetWeeklyStages() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'weekly_stage_reset';
    final lastReset = DateTime.parse(prefs.getString(key) ?? DateTime.now().toIso8601String());
    final now = DateTime.now();

    if (now.difference(lastReset).inDays >= 7) {
      await prefs.setString(key, now.toIso8601String());
      await prefs.setInt('stage_progress_${StageType.weekly.toString()}', 0);
    }
  }
}