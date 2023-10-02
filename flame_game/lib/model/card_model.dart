import 'package:json_annotation/json_annotation.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel {
  String name;

  CardModel(this.name);

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}