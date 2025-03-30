import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/card_data.dart';
import 'package:flame_game/model/enums.dart';
import 'package:flame_game/manager/role_manager.dart';
import 'package:flame_game/manager/card_manager.dart';
import 'dart:convert';

class GachaManager {
  static final GachaManager _instance = GachaManager._internal();
  static GachaManager get instance => _instance;
  
  final Random _random = Random();
  final RoleManager _roleManager = RoleManager.instance;
  late SharedPreferences _prefs;
  
  List<CardModel> _collectedCards = [];
  int _pityProgress = 0;
  
  GachaManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCollectedCards();
  }

  Future<void> _loadCollectedCards() async {
    final String? cardsJson = _prefs.getString('collected_cards');
    if (cardsJson != null) {
      final List<dynamic> list = jsonDecode(cardsJson);
      _collectedCards = list.map((json) => CardModel.fromJson(json)).toList();
    }
  }

  Future<void> _saveCollectedCards() async {
    final String cardsJson = jsonEncode(
      _collectedCards.map((card) => card.toJson()).toList(),
    );
    await _prefs.setString('collected_cards', cardsJson);
  }

  double _getSSRRate(GachaType type) {
    switch (type) {
      case GachaType.normal:
        return 0.01;
      case GachaType.premium:
        return 0.03;
      case GachaType.limited:
        return 0.05;
      case GachaType.event:
        return 0.10;
    }
  }

  double _getSRRate(GachaType type) {
    switch (type) {
      case GachaType.normal:
        return 0.10;
      case GachaType.premium:
        return 0.15;
      case GachaType.limited:
        return 0.20;
      case GachaType.event:
        return 0.25;
    }
  }

  double _getRRate(GachaType type) {
    switch (type) {
      case GachaType.normal:
        return 0.30;
      case GachaType.premium:
        return 0.35;
      case GachaType.limited:
        return 0.40;
      case GachaType.event:
        return 0.45;
    }
  }

  CardRank _drawRank(GachaType type) {
    if (_pityProgress >= 100) {
      _pityProgress = 0;
      return CardRank.SSR;
    }

    final double roll = _random.nextDouble();
    final double ssrRate = _getSSRRate(type);
    final double srRate = _getSRRate(type);
    final double rRate = _getRRate(type);

    if (roll < ssrRate) {
      _pityProgress = 0;
      return CardRank.SSR;
    } else if (roll < ssrRate + srRate) {
      _pityProgress += 1;
      return CardRank.SR;
    } else if (roll < ssrRate + srRate + rRate) {
      _pityProgress += 1;
      return CardRank.R;
    } else {
      _pityProgress += 1;
      return CardRank.N;
    }
  }

  Future<CardModel> draw(GachaType type) async {
    final rank = _drawRank(type);
    final cardType = _random.nextInt(4); // 0: 程式設計師, 1: 設計師, 2: 專案經理, 3: 行銷專員
    
    CardModel card;
    switch (cardType) {
      case 0:
        card = CardModel.createProgrammerCard(
          name: _getProgrammerName(rank),
          rank: rank,
          connect: 3,
          hpAdd: 80,
          mpAdd: 70,
          pointAdd: 60,
          createAdd: 80,
          popularAdd: 60,
        );
        break;
      case 1:
        card = CardModel.createDesignerCard(
          name: _getDesignerName(rank),
          rank: rank,
          connect: 3,
          hpAdd: 60,
          mpAdd: 60,
          pointAdd: 70,
          createAdd: 90,
          popularAdd: 70,
        );
        break;
      case 2:
        card = CardModel.createManagerCard(
          name: _getManagerName(rank),
          rank: rank,
          connect: 4,
          hpAdd: 70,
          mpAdd: 80,
          pointAdd: 80,
          createAdd: 60,
          popularAdd: 60,
        );
        break;
      default:
        card = CardModel.createMarketerCard(
          name: _getMarketerName(rank),
          rank: rank,
          connect: 3,
          hpAdd: 60,
          mpAdd: 70,
          pointAdd: 70,
          createAdd: 70,
          popularAdd: 80,
        );
    }
    
    card.collectedAt = DateTime.now();
    _collectedCards.add(card);
    await _saveCollectedCards();
    await _roleManager.addCard(card);
    await CardManager.instance.collectCard(card);
    await saveDrawHistory(card, type);
    return card;
  }

  String _getProgrammerName(CardRank rank) {
    switch (rank) {
      case CardRank.SSR:
        return '資深工程師';
      case CardRank.SR:
        return '中級工程師';
      case CardRank.R:
        return '初級工程師';
      case CardRank.N:
        return '實習工程師';
    }
  }

  String _getDesignerName(CardRank rank) {
    switch (rank) {
      case CardRank.SSR:
        return '資深設計師';
      case CardRank.SR:
        return '中級設計師';
      case CardRank.R:
        return '初級設計師';
      case CardRank.N:
        return '實習設計師';
    }
  }

  String _getManagerName(CardRank rank) {
    switch (rank) {
      case CardRank.SSR:
        return '資深經理';
      case CardRank.SR:
        return '中級經理';
      case CardRank.R:
        return '初級經理';
      case CardRank.N:
        return '實習經理';
    }
  }

  String _getMarketerName(CardRank rank) {
    switch (rank) {
      case CardRank.SSR:
        return '資深行銷';
      case CardRank.SR:
        return '中級行銷';
      case CardRank.R:
        return '初級行銷';
      case CardRank.N:
        return '實習行銷';
    }
  }

  int get pityProgress => _pityProgress;
  List<CardModel> get collectedCards => List.unmodifiable(_collectedCards);
  int get maxLevel => CardModel.getMaxLevel(_collectedCards);

  Future<void> saveDrawHistory(CardModel card, GachaType type) async {
    final String? historyJson = _prefs.getString('draw_history');
    List<Map<String, dynamic>> history = [];
    
    if (historyJson != null) {
      history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
    }
    
    history.add({
      'card': card.toJson(),
      'type': type.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    await _prefs.setString('draw_history', jsonEncode(history));
  }
} 