import 'package:flame_game/model/event_model.dart';

import '../model/card_model.dart';


class EventHelper{
  var week = 1;
  List<List<GameEvent>> eventList = [
    [],[]
  ];
  CardModel? currentCard;

  void setCurrentCard(CardModel card) {
    currentCard = card;
  }

  List<GameEvent> getCardEvents() {
    if (currentCard == null) return [];
    
    List<GameEvent> allEvents = [];
    allEvents.addAll(currentCard!.supportEvents);
    allEvents.addAll(currentCard!.storyEvents);
    allEvents.addAll(currentCard!.uniqueEvents);
    return allEvents;
  }

  void addSupportCardEvent(List<CardModel> list){
    for(int i=0;i<list.length;i++){
      list[i].storyEvents;
      list[i].supportEvents;
      list[i].uniqueEvents;
    }
    
    eventList[0].add(GameEvent(
      title: "好好上班",
      description: "辛苦的上了一天班~回去趕稿\n體力 -50\n專業 +50",
      mpEffect: 0,
      hpEffect: -50,
      pointEffect: 50,
      randomAble: false,
    ));
    eventList[0].add(GameEvent(
      title: "上班偷寫",
      description: "偷偷的~別發現我~\n體力 -30\n靈感 +10\n專業 +20",
      mpEffect: 10,
      hpEffect: -30,
      pointEffect: 20,
      randomAble: false,
    ));
    eventList[1].add(GameEvent(
      title: "和朋友運動",
      description: "從運動之中得到靈感~\n體力 +5\n靈感 +15\n專業 +10",
      mpEffect: 15,
      hpEffect: 5,
      pointEffect: 10,
      randomAble: false,
    ));
    eventList[1].add(GameEvent(
      title: "看表演",
      description: "太感動了!靈感噴發~\n體力 +10\n靈感 +50",
      mpEffect: 50,
      hpEffect: 10,
      pointEffect: 0,
      randomAble: false,
    ));
    eventList[1].add(GameEvent(
      title: "好好休息",
      description: "直接睡了半天~\n體力 +50\n靈感 +20",
      mpEffect: 20,
      hpEffect: 50,
      pointEffect: 0,
      randomAble: false,
    ));
    eventList[1].add(GameEvent(
      title: "發挖新知",
      description: "我就卷!!~\n體力 -40\n靈感 +20\n專業 +50",
      mpEffect: 20,
      hpEffect: -40,
      pointEffect: 50,
      randomAble: false,
    ));
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

  // 計算一天的總體力消耗
  int calculateDailyHpCost(List<GameEvent> selectedEvents) {
    return selectedEvents.fold(0, (sum, event) => sum + event.hpEffect.abs());
  }

  // 檢查是否所有事件都選擇完成
  bool areAllEventsSelected(List<GameEvent> selectedEvents) {
    return selectedEvents.length == 4;
  }

  // 檢查是否會導致體力耗盡
  bool willExhaustHp(List<GameEvent> selectedEvents, int currentHp) {
    return calculateDailyHpCost(selectedEvents) >= currentHp;
  }

  // 檢查是否為休息事件
  bool isRestEvent(GameEvent event) {
    return event.hpEffect > 0;
  }

  // 獲取所有休息事件
  List<GameEvent> getRestEvents() {
    return eventList[1].where((event) => isRestEvent(event)).toList();
  }

  // 獲取所有工作事件
  List<GameEvent> getWorkEvents() {
    return eventList[0].where((event) => !isRestEvent(event)).toList();
  }

  // 計算選擇的事件總體力恢復
  int calculateHpRecovery(List<GameEvent> selectedEvents) {
    return selectedEvents.fold(0, (sum, event) => sum + (event.hpEffect > 0 ? event.hpEffect : 0));
  }

  // 計算選擇的事件總體力消耗
  int calculateHpCost(List<GameEvent> selectedEvents) {
    return selectedEvents.fold(0, (sum, event) => sum + (event.hpEffect < 0 ? event.hpEffect.abs() : 0));
  }

  // 獲取當前角色的所有事件
  List<GameEvent> getCurrentCardEvents() {
    if (currentCard == null) return [];
    return getCardEvents();
  }

  // 獲取當前角色的支援事件
  List<GameEvent> getCurrentCardSupportEvents() {
    if (currentCard == null) return [];
    return currentCard!.supportEvents;
  }

  // 獲取當前角色的故事事件
  List<GameEvent> getCurrentCardStoryEvents() {
    if (currentCard == null) return [];
    return currentCard!.storyEvents;
  }

  // 獲取當前角色的特殊事件
  List<GameEvent> getCurrentCardUniqueEvents() {
    if (currentCard == null) return [];
    return currentCard!.uniqueEvents;
  }
}