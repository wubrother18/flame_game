import 'package:flame_game/model/event_model.dart';

import '../model/card_model.dart';


class EventHelper{
  var week = 1;
  List<List<GameEvent>> eventList = [
    [],[]
  ];

  addSupportCardEvent(List<CardModel> list){
    for(int i=0;i<list.length;i++){
      list[i].storyEvents;
      list[i].supportEvents;
      list[i].uniqueEvents;
    }
    
    eventList[0].add(GameEvent("好好上班", 0, -10, 10, false, true, "辛苦的上了一天班~回去趕稿\n體力 -10\n專業 +10"));
    eventList[0].add(GameEvent("上班偷寫", 10, -8, 2, false, true, "偷偷的~別發現我~\n體力 -8\n靈感 +10\n專業 +2"));
    eventList[1].add(GameEvent("和朋友運動", 10, -2, 2, false, true, "從運律之中得到靈感~\n體力 -2\n靈感 +10\n專業 +2"));
    eventList[1].add(GameEvent("看表演", 25, 4, 0, false, true, "太感動了!靈感噴發~\n體力 +4\n靈感 +25"));
    eventList[1].add(GameEvent("好好休息", 5, 200, 0, false, true, "直接睡了半天~\n體力 +12\n靈感 +5"));
    eventList[1].add(GameEvent("發挖新知", 2, -4, 15, false, true, "我就卷!!~\n體力 -4\n靈感 +2\n專業 +15"));
  }

  List<GameEvent> getEvent(int days){
    if((days - 7* week) >= 0){
      if((days - 7* week) >= 1){
        week++;
      }
      return eventList[1];
    }else{
      return eventList[0];
    }

  }
}