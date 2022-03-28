import 'package:flutter/material.dart';
import 'shopping_list.dart';

class ShoppingListPage extends StatelessWidget {
  final String name;
  const ShoppingListPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),

      body: Center(
        child: ShoppingListView(listName: name),
      ),
    );
  }
}