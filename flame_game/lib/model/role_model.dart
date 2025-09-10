import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/static.dart';
import 'dart:math';
import 'event_model.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'package:flame_game/model/enums.dart';

class Role {
  int _hp = 100;
  int _mp = 100;
  int _point = 0;
  int _professional = 0;
  int _create = 0;
  int _popular = 0;
  int _level = 1;
  List<CardModel> cards = [];
  String _name = '遊戲開發者';

  // Getters
  int get hp => _hp;
  int get mp => _mp;
  int get point => _point;
  int get professional => _professional;
  int get create => _create;
  int get popular => _popular;
  int get level => _level;
  String get name => _name;

  // 獲取最大體力值
  int get maxHp => 100 + (level - 1) * 20;

  // 獲取最大靈感值
  int get maxMp => 200 + (level - 1) * 100;

  // Setters
  set hp(int value) => _hp = value.clamp(0, 99999);
  set mp(int value) => _mp = value.clamp(0, 99999);
  set point(int value) => _point = value.clamp(0, 99999);
  set professional(int value) => _professional = value.clamp(0, 99999);
  set create(int value) => _create = value.clamp(0, 99999);
  set popular(int value) => _popular = value.clamp(0, 99999);
  set level(int value) => _level = value.clamp(1, 100);
  set name(String value) => _name = value;

  //初始化數值
  void init() {
    _hp = 100;
    _mp = 100;
    _point = 0;
    _professional = 0;
    _create = 0;
    _popular = 0;
    _level = 1;
  }

  // 升級角色
  bool upgrade() {
    final requiredPoint = _level * 100;
    if (_point >= requiredPoint) {
      _point -= requiredPoint;
      _level++;
      return true;
    }
    return false;
  }

  // 處理事件
  void handleEvent(GameEvent event) {
    // 處理事件效果
    hp = (hp + event.hpEffect);
    mp = (mp + event.mpEffect);
    
    // 更新屬性（不受體力和靈感影響，且沒有上限）
    point = (point + event.pointEffect).toInt();
    create = (create + event.createEffect).toInt();
    popular = (popular + event.popularEffect).toInt();
  }

  // 每天恢復
  void dailyRecovery() {
    // 每天恢復一些體力和靈感
    hp = (hp + 20);
    mp = (mp + 20);
  }

  getEvent(GameEvent event) {
    if (event.randomAble ?? false) {
      // 處理隨機事件
    } else {
      hp += event.hpEffect ?? 0;
      mp += event.mpEffect ?? 0;
      point += event.pointEffect ?? 0;
    }

    ///成就判定
    if (event.title.compareTo("好好上班") == 0) {
      final achievement = Achievement(
        id: "hard_work",
        name: "努力工作",
        description: "完成工作事件",
        type: AchievementType.event,
        maxProgress: 1,
        expReward: 100,
        itemRewards: {'gem': 10},
        tier: 1,
        currentProgress: 1,
        claimed: false,
      );
      StaticFunction.instance.achieveManager.add(achievement);
    }
  }

  void setCard(List<CardModel> list) {
    cards = list;
    // 根據卡片更新屬性
    for (var card in cards) {
      if(card == cards.first){
        hp += card.baseHp;
        mp += card.baseMp;
        point += card.basePoint;
        create += card.baseCreate ?? 0;
        popular += card.basePopular ?? 0;
      }else{
        hp += card.hpAdd;
        mp += card.mpAdd;
        point += card.pointAdd;
        create += card.createAdd ?? 0;
        popular += card.popularAdd ?? 0;
      }
    }
  }
}