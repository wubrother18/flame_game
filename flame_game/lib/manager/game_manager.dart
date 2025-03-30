import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game/manager/event_helper.dart';
import 'package:flame_game/manager/story_manager.dart';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/event_model.dart';
import 'package:flame_game/static.dart';
import 'package:flame_game/model/enums.dart';

import '../model/role_model.dart';
import '../model/achievement_model.dart';

class GameManager {
  static GameManager gameManager = GameManager();
  late Role role;
  EventHelper? eventHelper;
  StoryManager? storyManager;
  List<CardModel>? cardList;
  int day = 1;
  int create = 0;
  int point = 0;
  int popular = 0;
  List<GameEvent> events = [];
  bool isGameOver = false;
  int score = 0;
  Function? callBack;
  Random random = Random();
  late AchievementManager achieveManager;
  int selectedEventCount = 0;
  String failureReason = "";

  static GameManager ins() {
    return gameManager;
  }

  GameManager() {
    role = Role();
    achieveManager = AchievementManager.instance;
  }

  Future<void> start() async {
    await FlameAudio.audioCache.loadAll([
      'poka.mp3',
      'badend1.mp3',
      'adventure.mp3',
    ]);
  }

  Future<void> init(List<CardModel> list, Function(String end) callBack) async {
    cardList = list;
    day = 1;
    eventHelper = EventHelper();
    storyManager = StoryManager.instance;
    role.setCard(list);
    eventHelper?.addSupportCardEvent(list);
    this.callBack = callBack;
    
    // 初始化成就
    await achieveManager.initialize();
    
    // 生成初始事件
    _generateEvents();
  }

  void _generateEvents() {
    events.clear();
    
    if (eventHelper != null) {
      List<GameEvent> predefinedEvents = eventHelper!.getEvent(day);
      events.addAll(predefinedEvents);
    }

    int randomCount = 3 + random.nextInt(3);
    for (int i = 0; i < randomCount; i++) {
      events.add(_generateRandomEvent());
    }

    if (cardList != null && cardList!.isNotEmpty) {
      List<GameEvent> allCardEvents = [];
      
      for (var card in cardList!) {
        allCardEvents.addAll(card.supportEvents);
        allCardEvents.addAll(card.storyEvents);
        allCardEvents.addAll(card.uniqueEvents);
      }
      
      events.addAll(allCardEvents);
    }

    events.shuffle(random);
  }

  GameEvent _generateRandomEvent() {
    int hpEffect = random.nextBool() ? 20 : -15 - random.nextInt(10);
    int pointEffect = 10 + random.nextInt(30);
    int createEffect = 10 + random.nextInt(30);
    int mpEffect = 5 + random.nextInt(20);
    int popularEffect = 5 + random.nextInt(15);

    return GameEvent(
      title: "隨機事件",
      description: "這是一個隨機事件\n體力 ${hpEffect >= 0 ? '+' : ''}$hpEffect\n專業 +$pointEffect\n靈感 +$mpEffect\n創意 +$createEffect\n人氣 +$popularEffect",
      hpEffect: hpEffect,
      mpEffect: mpEffect,
      pointEffect: pointEffect,
      createEffect: createEffect,
      popularEffect: popularEffect,
      randomAble: true,
    );
  }

  void getNext() {
    if (day == 30) {
      end("pass");
      return;
    }
    if (role.hp <= 0) {
      end("fail");
      return;
    }

    var cd = random.nextInt(role.mp);
    create += cd;
    role.mp -= cd;
    
    var pd = random.nextInt(role.point);
    point += pd;
    role.point -= pd;
    
    var newPopular = random.nextInt(100);
    popular += newPopular;
    
    _generateEvents();
  }

  void handleEvent(GameEvent event) {
    if (role.hp < 15 && event.hpEffect >= 0) {
      return;
    }

    if (cardList != null && cardList!.isNotEmpty) {
      int totalLevel = cardList!.fold(0, (sum, card) => sum + card.level);
      int averageLevel = (totalLevel / cardList!.length).ceil();
      
      event.hpEffect = (event.hpEffect * averageLevel).toInt();
      event.mpEffect = (event.mpEffect * averageLevel).toInt();
      event.pointEffect = (event.pointEffect * averageLevel).toInt();
      event.createEffect = (event.createEffect * averageLevel).toInt();
      event.popularEffect = (event.popularEffect * averageLevel).toInt();
    }

    role.handleEvent(event);
    events.remove(event);
    selectedEventCount++;

    if (selectedEventCount >= 3) {
      nextDay();
    }
  }

  void nextDay() {
    selectedEventCount = 0;
    _checkAchievements();
    _handleDailySummary();
    day++;
    if (day > 30) {
      isGameOver = true;
      return;
    }
    role.dailyRecovery();
    _generateEvents();
  }

  void _handleDailySummary() {
    int requiredMp = day * 10;
    int requiredPp = day * 10;

    if (role.mp < requiredMp || role.point < requiredPp) {
      isGameOver = true;
      if (role.mp < requiredMp) {
        failureReason = "靈感不足，無法完成今天的文章撰寫。";
      } else if (role.point < requiredPp) {
        failureReason = "專業度不足，無法完成今天的文章撰寫。";
      }
      return;
    }

    role.mp -= requiredMp;
    role.point -= requiredPp;

    int level = role.level;
    role.create += requiredMp * level;
    role.point += requiredPp * level;
    
    int totalConsumed = requiredMp + requiredPp;
    double popularityMultiplier = random.nextDouble();
    role.popular += (totalConsumed * level * popularityMultiplier).toInt();

    if (callBack != null) {
      callBack!('daily_summary');
    }
  }

  void _checkAchievements() async {
    // 更新成就進度
    await achieveManager.updateProgress(AchievementType.event, 1, selectedEventCount);
    await achieveManager.updateProgress(AchievementType.level, 10, role.level);
    await achieveManager.updateProgress(AchievementType.collection, 1, cardList?.length ?? 0);
    await achieveManager.updateProgress(AchievementType.special, 1, popular);
  }

  void end(String result) {
    if (result == "pass") {
      score = calculateScore();
    }
    isGameOver = true;
    if (callBack != null) {
      callBack!(result);
    }
  }

  int calculateScore() {
    int baseScore = 1000;
    int levelBonus = role.level * 100;
    int popularBonus = popular * 10;
    int createBonus = create * 5;
    int pointBonus = point * 5;
    
    return baseScore + levelBonus + popularBonus + createBonus + pointBonus;
  }
}
