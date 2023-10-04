import 'package:flame_game/model/card_model.dart';

import 'event_model.dart';

class ExampleCard {
  @override
  String name = "Example";   ///名稱
  int rank = 5;              ///稀有度
  int level = 1;             ///等級
  int connect = 0;           ///羈絆
  int hpAdd = 10;            ///體力增加值
  int mpAdd = 10;            ///靈感增加值
  int pointAdd = 20;         ///專業增加值
  List<GameEvent> supportEvents = [];///夥伴事件
  List<GameEvent> storyEvents = [];  ///主線事件
  List<GameEvent> uniqueEvents = []; ///獨有事件

  CardModel getCard(){
    return CardModel(name,rank,level,connect,hpAdd,mpAdd,pointAdd,supportEvents,storyEvents,uniqueEvents);
  }
}
