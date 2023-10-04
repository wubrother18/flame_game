import 'package:flame_game/model/event_model.dart';

import '../model/card_model.dart';


class EventHelper{
  List<GameEvent> eventList = [];

  addSupportCardEvent(List<CardModel> list){
    for(int i=0;i<list.length;i++){
      list[i].storyEvents;
      list[i].supportEvents;
      list[i].uniqueEvents;
    }
    
    eventList.add(GameEvent("上班", 0, -8, 10, false, true, "辛苦的上了一天班~\n體力 -8\n專業 +10"));
    eventList.add(GameEvent("和朋友運動", 10, -2, 2, true, true, "從運律之中得到靈感~\n體力 -4\n靈感 +10\n專業 +2"));
  }

  GameEvent getEvent(){
    return eventList[0];
  }
}