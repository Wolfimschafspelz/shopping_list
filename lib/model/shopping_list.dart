import 'package:shopping_list/model/shopping_item.dart';

class ShoppingListModel {
  final String name;
  List<ShoppingItem> items;

  ShoppingListModel(this.name, this.items);

  factory ShoppingListModel.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;
    List<ShoppingItem> items = [];

    for(var item in data['items']) {
      items.add(ShoppingItem.fromJson(item));
    }

    return ShoppingListModel(name, items);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> items = [];
    for(ShoppingItem item in this.items) {
      items.add(item.toJson());
    }

    return {
      'name' : name,
      'items' : items,
    };
  }
}