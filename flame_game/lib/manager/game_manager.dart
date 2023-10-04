import 'package:flame_game/manager/event_helper.dart';
import 'package:flame_game/manager/story_manager.dart';
import 'package:flame_game/model/card_model.dart';

import '../model/role_model.dart';

class GameManager {
  static GameManager gameManager = GameManager();
  Role? role;
  EventHelper? eventHelper;
  StoryManager? storyManager;
  List<CardModel>? cardList;
  int days = 0;
  int create = 0;
  int point = 0;
  int popular = 0;

  static GameManager ins() {
    return gameManager;
  }

  init(List<CardModel> list) {
    cardList = list;
    days = 1;
    eventHelper = EventHelper();
    storyManager = StoryManager();
    role = Role();
    role?.setCard(list);
    eventHelper?.addSupportCardEvent([]);
  }

  start() async {}

  end() {}
}
