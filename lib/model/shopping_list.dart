import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list/model/shopping_item.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList {
  final String id;

  final String ownerId;

  final String name;

  List<ShoppingItem> items;

  ShoppingList(this.id, this.ownerId, this.name, {this.items = const []});

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}
