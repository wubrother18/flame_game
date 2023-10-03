
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
  }
}