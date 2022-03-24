import 'package:flutter/material.dart';

///Model class to represent items to shop
class ShoppingItem {
  final String name;
  final int amount;

  ShoppingItem(this.name, this.amount);
}

class ShoppingListElement extends StatefulWidget {
  const ShoppingListElement({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementState();
}

class _ElementState extends State<ShoppingListElement> {
  ShoppingItem item = ShoppingItem('Test', 0);
  bool? bought = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: bought, onChanged: (bool? state) {
          setState(() {
            bought = state;
          });
        }),

        Text(item.name),
      ],
    );
  }
}

class ShoppingListView extends StatefulWidget {

  const ShoppingListView({Key? key}) : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  List<ShoppingListElement> items = [const ShoppingListElement(),const ShoppingListElement(),const ShoppingListElement()];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, index) {
        return items[index];
      },
    );
  }
}