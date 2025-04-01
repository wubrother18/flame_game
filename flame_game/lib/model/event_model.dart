import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class GameEvent {
  @JsonKey(name: 'title')
  final String title;
  
  @JsonKey(name: 'description')
  final String description;
  
  @JsonKey(name: 'mpEffect')
  int mpEffect;
  
  @JsonKey(name: 'hpEffect')
  int hpEffect;
  
  @JsonKey(name: 'pointEffect')
  int pointEffect;
  
  @JsonKey(name: 'createEffect')
  int createEffect;
  
  @JsonKey(name: 'popularEffect')
  int popularEffect;

  @JsonKey(name: 'professionalEffect')
  int professionalEffect;
  
  @JsonKey(name: 'randomAble')
  final bool randomAble;

  GameEvent({
    required this.title,
    required this.description,
    required this.mpEffect,
    required this.hpEffect,
    required this.pointEffect,
    this.createEffect = 0,
    this.popularEffect = 0,
    this.professionalEffect = 0,
    required this.randomAble,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) => _$GameEventFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$GameEventToJson(this);
}
