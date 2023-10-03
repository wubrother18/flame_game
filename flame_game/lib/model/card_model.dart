import 'package:json_annotation/json_annotation.dart';

import 'event_model.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel {
  String name;
  int rank;
  int level;
  int connect;
  int hpAdd;
  int mpAdd;
  int pointAdd;
  List<GameEvent> supportEvents;
  List<GameEvent> storyEvents;
  List<GameEvent> uniqueEvents;


  CardModel(
      this.name,
      this.rank,
      this.level,
      this.connect,
      this.hpAdd,
      this.mpAdd,
      this.pointAdd,
      this.supportEvents,
      this.storyEvents,
      this.uniqueEvents);

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}