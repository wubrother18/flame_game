import 'dart:math';

import 'package:flame_game/manager/event_helper.dart';
import 'package:flame_game/manager/story_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/event_model.dart';

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
  List<GameEvent>? eventList;
  Function? callBack;

  static GameManager ins() {
    return gameManager;
  }

  init(List<CardModel> list, Function(String end) callBack) {
    cardList = list;
    days = 1;
    eventHelper = EventHelper();
    storyManager = StoryManager();
    role = Role();
    role?.setCard(list);
    eventHelper?.addSupportCardEvent([]);
    eventList = eventHelper?.getEvent(days);
    this.callBack = callBack;
  }

  getNext(){
    if(days == 30){
      end("pass");
    }
    if(role!.hp<0){
      end("fail");
    }
    days++;
    var cd = Random().nextInt(role?.mp??0);
    create += cd;
    role?.mp -= cd;
    var pd =  Random().nextInt(role?.point??0);
    point += pd;
    role?.point -=pd;
    popular += Random().nextInt(100);
    eventList = eventHelper?.getEvent(days);
  }
  start() async {}

  end(String end) {
    callBack?.call(end);
  }
}
