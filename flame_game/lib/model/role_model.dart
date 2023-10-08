
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/static.dart';

import 'event_model.dart';

class Role {
  int hp=0,mp=0,point =0;
  String name = "";

  getEvent(GameEvent event){
    if(event.randomAble??false){
      
    }else{
      hp += event.hpEffect??0;
      mp += event.mpEffect??0;
      point += event.pointEffect??0;
    }

    ///成就判定
    if(event.title!.compareTo("好好上班")==0){
      StaticFunction.getInstance().achieveManager.add({"hard_work":1});
    }
  }

  setCard(List<CardModel> cardList){
    name = cardList[0].name;
    for(int i=0;i<cardList.length;i++){
      hp += cardList[i].hpAdd;
      mp += cardList[i].mpAdd;
      point += cardList[i].pointAdd;
    }
  }
}