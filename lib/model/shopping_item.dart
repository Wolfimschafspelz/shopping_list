import 'package:json_annotation/json_annotation.dart';

part 'shopping_item.g.dart';

enum Measure {
  none,
  l,
  kg,
}

@JsonSerializable()
class ShoppingItem {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true, defaultValue: 1)
  double amount;

  @JsonKey(required: true, defaultValue: false)
  bool bought;

  @JsonKey(required: true, defaultValue: 0.0)
  double price;

  @JsonKey(required: true)
  Measure unit;

  ShoppingItem(this.id,
      {required this.name,
      this.bought = false,
      this.price = 0.0,
      this.amount = 1,
      this.unit = Measure.none});

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);
}
