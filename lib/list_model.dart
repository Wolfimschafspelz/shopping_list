class ShoppingListModel {
  final String name;

  ShoppingListModel(this.name);

  factory ShoppingListModel.fromJson(Map<String, dynamic> data) {
    final name = data['name'] as String;

    return ShoppingListModel(name);
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
    };
  }
}