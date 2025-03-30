import 'package:flame_game/model/event_model.dart';
import 'package:flame_game/model/card_model.dart';

class StoryManager {
  static final StoryManager _instance = StoryManager._internal();
  static StoryManager get instance => _instance;
  
  List<GameEvent> _storyEvents = [];
  CardModel? _currentCard;
  
  StoryManager._internal();
  
  void setCurrentCard(CardModel card) {
    _currentCard = card;
    _loadStoryEvents();
  }
  
  void _loadStoryEvents() {
    if (_currentCard == null) return;
    _storyEvents = List.from(_currentCard!.storyEvents);
  }
  
  List<GameEvent> getStoryEvents() {
    return List.unmodifiable(_storyEvents);
  }
  
  void completeStoryEvent(GameEvent event) {
    _storyEvents.remove(event);
  }
  
  bool hasStoryEvents() {
    return _storyEvents.isNotEmpty;
  }
  
  GameEvent? getNextStoryEvent() {
    if (_storyEvents.isEmpty) return null;
    return _storyEvents.first;
  }
}