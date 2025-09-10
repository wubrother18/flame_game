import 'dart:convert';
import 'package:flame_game/model/enums.dart';
import 'package:flutter/services.dart';
import 'package:flame_game/model/card_model.dart';

class CardConfigService {
  static final CardConfigService _instance = CardConfigService._internal();
  static CardConfigService get instance => _instance;

  List<CardModel> _cards = [];
  bool _isInitialized = false;

  CardConfigService._internal();

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/cards.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cards = jsonList.map((json) => CardModel.fromJson(json)).toList();
      _isInitialized = true;
    } catch (e) {
      print('Error loading cards: $e');
      rethrow;
    }
  }

  List<CardModel> getAllCards() {
    if (!_isInitialized) {
      throw StateError('CardConfigService not initialized');
    }
    return List.unmodifiable(_cards);
  }

  List<CardModel> getCardsByRank(CardRank rank) {
    if (!_isInitialized) {
      throw StateError('CardConfigService not initialized');
    }
    return List.unmodifiable(_cards.where((card) => card.rank == rank).toList());
  }

  CardModel? getCardById(String id) {
    if (!_isInitialized) {
      throw StateError('CardConfigService not initialized');
    }
    return _cards.firstWhere(
      (card) => card.id == id,
      orElse: () => throw Exception('Card not found for id: $id'),
    );
  }

  List<CardRank> getAllRanks() {
    if (!_isInitialized) {
      throw StateError('CardConfigService not initialized');
    }
    return _cards.map((card) => card.rank).toSet().toList();
  }

  bool isInitialized() => _isInitialized;
} 