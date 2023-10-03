import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class GameEvent {
  String? title;

  ///靈感修改量
  int? mpEffect;

  ///體力修改量
  int? hpEffect;

  ///專業度
  int? pointEffect;
  bool? randomAble;
  bool? hasAnimate;
  String? describe;


  GameEvent(this.title, this.mpEffect, this.hpEffect, this.pointEffect,
      this.randomAble, this.hasAnimate, this.describe);

  factory GameEvent.fromJson(Map<String, dynamic> json) => _$GameEventFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$GameEventToJson(this);
}
