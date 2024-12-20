import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_list.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList list;
  final void Function()? onPressedDelete;
  final void Function()? onTap;

  const ShoppingListTile(this.list,
      {super.key, this.onPressedDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(list.name),
      subtitle: LinearProgressIndicator(
        value: list.items.isNotEmpty
            ? list.items.where((item) => item.bought).length / list.items.length
            : 0,
      ),
      trailing:
          IconButton(onPressed: onPressedDelete, icon: Icon(Icons.delete)),
    );
  }
}
