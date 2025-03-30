import 'dart:convert';
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
  static const String _expKey = 'card_experience';

  List<CardModel> get collectedCards => List.unmodifiable(_collectedCards);

  CardManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _experience = _prefs.getInt(_expKey) ?? 0;
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

  Future<void> _saveCollectedCards() async {
    final String cardsJson = jsonEncode(
      _collectedCards.map((card) => card.toJson()).toList(),
    );
    await _prefs.setString('collected_cards', cardsJson);
  }

  void addCard(CardModel card) {
    if (!_collectedCards.any((c) => c.id == card.id)) {
      _collectedCards.add(card);
      _saveCollectedCards();
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

  Future<bool> upgradeCard(CardModel card) async {
    if (!hasCard(card.id)) return false;
    
    final index = _collectedCards.indexWhere((c) => c.id == card.id);
    if (index == -1) return false;

    final currentCard = _collectedCards[index];
    if (currentCard.level >= currentCard.maxLevel) return false;

    currentCard.addExperience(100);
    await _saveCollectedCards();
    return true;
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

  Future<void> collectCard(CardModel card) async {
    if (!_collectedCards.contains(card)) {
      _collectedCards.add(card);
      await _saveCollectedCards();
    } else {
      // 如果已經擁有這張卡片，轉換為經驗值
      final expValue = _calculateCardExpValue(card);
      await addExperience(expValue);
    }
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

  Future<bool> useExperience(int amount) async {
    if (_experience >= amount) {
      _experience -= amount;
      await _prefs.setInt(_expKey, _experience);
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

  Future<void> addExperienceFromAchievement(int exp) async {
    await addExperience(exp);
  }

  Future<void> removeCard(CardModel card) async {
    _collectedCards.removeWhere((c) => c.id == card.id);
    await _saveCollectedCards();
  }

  Map<String, int> getCardStats() {
    return {
      'collectedCards': _collectedCards.length,
      'totalCards': allCards.length,
      'maxLevel': _collectedCards.fold(0, (max, card) => card.level > max ? card.level : max),
      'experience': _experience,
    };
  }
} 