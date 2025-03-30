import 'package:json_annotation/json_annotation.dart';

import 'card_model.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  String id;
  String name;
  int gameLevel;
  String title;
  String type;
  List<CardModel> cards;
  List<String> childList;
  
  // 遊戲狀態
  int currentHp;
  int currentMp;
  int point;
  int create;
  int popular;
  int daysPlayed;
  int eventsCompleted;
  Map<String, int> upgrades;
  Map<String, int> inventory;
  List<String> completedAchievements;
  String? currentCardId;

  UserData(
    this.id,
    this.name,
    this.gameLevel,
    this.title,
    this.type,
    this.childList,
    this.cards, {
    this.currentHp = 100,
    this.currentMp = 50,
    this.point = 0,
    this.create = 0,
    this.popular = 0,
    this.daysPlayed = 0,
    this.eventsCompleted = 0,
    this.upgrades = const {},
    this.inventory = const {},
    this.completedAchievements = const [],
    this.currentCardId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  // 計算最大體力值
  int get maxHp => 100 + (gameLevel - 1) * 10;
  // 計算最大靈感值
  int get maxMp => 50 + (gameLevel - 1) * 5;

  // 更新遊戲狀態
  UserData updateGameState({
    int? currentHp,
    int? currentMp,
    int? point,
    int? create,
    int? popular,
    int? daysPlayed,
    int? eventsCompleted,
    Map<String, int>? upgrades,
    Map<String, int>? inventory,
    List<String>? completedAchievements,
    String? currentCardId,
  }) {
    return UserData(
      id,
      name,
      gameLevel,
      title,
      type,
      childList,
      cards,
      currentHp: currentHp ?? this.currentHp,
      currentMp: currentMp ?? this.currentMp,
      point: point ?? this.point,
      create: create ?? this.create,
      popular: popular ?? this.popular,
      daysPlayed: daysPlayed ?? this.daysPlayed,
      eventsCompleted: eventsCompleted ?? this.eventsCompleted,
      upgrades: upgrades ?? this.upgrades,
      inventory: inventory ?? this.inventory,
      completedAchievements: completedAchievements ?? this.completedAchievements,
      currentCardId: currentCardId ?? this.currentCardId,
    );
  }

  // 獲取當前角色
  CardModel? getCurrentCard() {
    if (currentCardId == null) return null;
    return cards.firstWhere(
      (card) => card.name == currentCardId,
      orElse: () => cards.first,
    );
  }

  // 設置當前角色
  UserData setCurrentCard(String cardName) {
    return updateGameState(currentCardId: cardName);
  }

  // 更新體力
  UserData updateHp(int amount) {
    int newHp = currentHp + amount;
    if (newHp > maxHp) newHp = maxHp;
    if (newHp < 0) newHp = 0;
    return updateGameState(currentHp: newHp);
  }

  // 更新靈感
  UserData updateMp(int amount) {
    int newMp = currentMp + amount;
    if (newMp > maxMp) newMp = maxMp;
    if (newMp < 0) newMp = 0;
    return updateGameState(currentMp: newMp);
  }

  // 更新專業度
  UserData updatePoint(int amount) {
    return updateGameState(point: point + amount);
  }

  // 更新創意點數
  UserData updateCreate(int amount) {
    return updateGameState(create: create + amount);
  }

  // 更新人氣值
  UserData updatePopular(int amount) {
    return updateGameState(popular: popular + amount);
  }

  // 更新遊玩天數
  UserData incrementDaysPlayed() {
    return updateGameState(daysPlayed: daysPlayed + 1);
  }

  // 更新完成事件數
  UserData incrementEventsCompleted() {
    return updateGameState(eventsCompleted: eventsCompleted + 1);
  }

  // 更新升級狀態
  UserData updateUpgrade(String upgradeId, int level) {
    final newUpgrades = Map<String, int>.from(upgrades);
    newUpgrades[upgradeId] = level;
    return updateGameState(upgrades: newUpgrades);
  }

  // 更新物品欄
  UserData updateInventory(String itemId, int count) {
    final newInventory = Map<String, int>.from(inventory);
    if (count <= 0) {
      newInventory.remove(itemId);
    } else {
      newInventory[itemId] = count;
    }
    return updateGameState(inventory: newInventory);
  }

  // 更新成就
  UserData addAchievement(String achievementId) {
    if (completedAchievements.contains(achievementId)) return this;
    return updateGameState(
      completedAchievements: [...completedAchievements, achievementId],
    );
  }

  // 檢查是否完成特定成就
  bool hasAchievement(String achievementId) {
    return completedAchievements.contains(achievementId);
  }

  // 檢查是否體力耗盡
  bool isExhausted() {
    return currentHp <= 0;
  }

  // 檢查是否完成所有事件
  bool hasCompletedAllEvents() {
    return eventsCompleted >= 4;
  }
}