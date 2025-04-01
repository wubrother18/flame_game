import 'dart:convert';
import 'package:flame_game/manager/achievement_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/data/card_data.dart';

class CardManager {
  static final CardManager _instance = CardManager._internal();
  static CardManager get instance => _instance;
  late SharedPreferences _prefs;
  
  final List<CardModel> allCards = CardData.getAllCards();
  final List<CardModel> _collectedCards = [];
  int _experience = 0;
  int _gem = 0;
  static const String _expKey = 'card_experience';
  static const String _gemKey = 'card_gem';

  List<CardModel> get collectedCards => List.unmodifiable(_collectedCards);

  CardManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _experience = _prefs.getInt(_expKey) ?? 0;
    _gem = _prefs.getInt(_gemKey) ?? 0;
    await _loadCollectedCards();
  }

  Future<void> _loadCollectedCards() async {
    final String? cardsJson = _prefs.getString('collected_cards');
    if (cardsJson != null) {
      final List<dynamic> list = jsonDecode(cardsJson);
      _collectedCards.clear();
      _collectedCards.addAll(
        list.map((json) => CardModel.fromJson(json)).toList(),
      );
    }
  }

  Future<void> saveCollectedCards() async {
    final String cardsJson = jsonEncode(
      _collectedCards.map((card) => card.toJson()).toList(),
    );
    await _prefs.setString('collected_cards', cardsJson);
  }

  void addCard(CardModel card) {
    if (!_collectedCards.any((c) => c.id == card.id)) {
      _collectedCards.add(card);
      saveCollectedCards();
    }
  }

  bool hasCard(String cardId) {
    return _collectedCards.any((card) => card.id == cardId);
  }

  List<CardModel> getCollectedCards() {
    return List.unmodifiable(_collectedCards);
  }

  int getCollectedCardCount() {
    return _collectedCards.length;
  }

  Future<bool> upgradeCard(CardModel card, int expAmount) async {
    if (expAmount <= 0) return false;
    if (!card.canLevelUp(expAmount)) return false;
    
    // 先扣除經驗值
    _experience -= expAmount;
    
    // 升級卡片
    card.addExperience(expAmount);
    
    // 保存所有更改
    await saveCollectedCards();
    await saveExperience();
    
    return true;
  }

  Future<bool> decomposeCard(CardModel card) async {
    try {
      // 計算返還的經驗值
      int returnedExp = 0;
      int returnedGem = 0;

      // 基礎經驗值（根據稀有度）
      returnedExp += switch (card.rank) {
        CardRank.SSR => 1000,
        CardRank.SR => 500,
        CardRank.R => 200,
        CardRank.N => 100,
      };
      
      // 加上卡片升級花費的經驗值
      for (int i = 1; i < card.level; i++) {
        returnedExp += i * 100; // 每級升級所需經驗值
      }
      
      // 加上突破花費的經驗值
      for (int i = 0; i < card.breakthrough; i++) {
        returnedExp += 500; // 每次突破所需經驗值
        returnedGem += 100;
      }

      // 從收藏中移除卡片
      _collectedCards.removeWhere((c) => c.id == card.id);
      
      // 將經驗值加入經驗池
      _experience += returnedExp;
      _gem += returnedGem;

      // 保存狀態
      await saveCollectedCards();
      
      return true;
    } catch (e) {
      print('Error decomposing card: $e');
      return false;
    }
  }

  List<CardModel> getCardsByRank(CardRank rank) {
    return _collectedCards.where((card) => card.rank == rank).toList();
  }

  List<CardModel> searchCards(String query) {
    query = query.toLowerCase();
    return _collectedCards.where((card) {
      return card.name.toLowerCase().contains(query) ||
             card.description.toLowerCase().contains(query);
    }).toList();
  }

  int get experience => _experience;
  int get gem => _gem;

  Future<void> collectCard(CardModel card) async {
    if (!_collectedCards.contains(card)) {
      card.collectedAt = DateTime.now();
      _collectedCards.add(card);
      await saveCollectedCards();
    } else {
      // 如果已經擁有這張卡片，轉換為經驗值
      final expValue = _calculateCardExpValue(card);
      await addExperience(expValue);
    }
    // 檢查收藏成就
    await AchievementManager.instance.updateProgress(AchievementType.collection, 1, _collectedCards.length ?? 0);
    await AchievementManager.instance.updateProgress(AchievementType.collection, 5, _collectedCards.length ?? 0);
    await AchievementManager.instance.updateProgress(AchievementType.collection, 10, _collectedCards.length ?? 0);
  }

  int _calculateCardExpValue(CardModel card) {
    final baseExp = switch (card.rank) {
      CardRank.N => 100,
      CardRank.R => 200,
      CardRank.SR => 500,
      CardRank.SSR => 1000,
    };
    return (baseExp * (1 + card.level * 0.1)).toInt();
  }

  Future<void> addExperience(int amount) async {
    _experience += amount;
    await _prefs.setInt(_expKey, _experience);
  }

  Future<void> addGem(int amount) async {
    _gem += amount;
    await _prefs.setInt(_gemKey, _gem);
  }

  Future<bool> useExperience(int amount) async {
    if (_experience >= amount) {
      _experience -= amount;
      await _prefs.setInt(_expKey, _experience);
      return true;
    }
    return false;
  }

  Future<bool> useGems(int amount) async {
    if (_gem >= amount) {
      _gem -= amount;
      await _prefs.setInt(_gemKey, _gem);
      return true;
    }
    return false;
  }

  Future<void> addExperienceFromLevel(int level) async {
    final exp = 100 + (level * 50);
    await addExperience(exp);
  }

  Future<void> addExperienceFromDailyTask() async {
    final exp = 100 + (DateTime.now().millisecondsSinceEpoch % 100);
    await addExperience(exp);
  }

  Future<void> addExperienceFromAchievement(int exp, int gem) async {
    await addExperience(exp);
    await addGem(gem);
  }

  Future<void> removeCard(CardModel card) async {
    _collectedCards.removeWhere((c) => c.id == card.id);
    await saveCollectedCards();
  }

  Map<String, int> getCardStats() {
    return {
      'collectedCards': _collectedCards.length,
      'totalCards': allCards.length,
      'maxLevel': _collectedCards.fold(0, (max, card) => card.level > max ? card.level : max),
      'experience': _experience,
    };
  }

  Future<void> saveExperience() async {
    await _prefs.setInt(_expKey, _experience);
  }
} 