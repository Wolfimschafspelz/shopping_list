///Model class to represent items to shop
/// @author Lukas Steinmann <lukas.steinmann@gmx.de>
class ShoppingItem {
  bool? bought;
  final String name;
  final int? amount;

  ShoppingItem(this.bought, this.name, this.amount);

  factory ShoppingItem.fromJson(Map<String, dynamic> data)
  {
    final bought = data['bought'] as bool?;
    final name = data['name'] as String;
    final amount = data['amount'] as int?;
    return ShoppingItem(bought, name, amount);
  }

  Map<String, dynamic> toJson() {
    return {
      'bought': bought,
      'name': name,
      'amount': amount,
    };
  }
}